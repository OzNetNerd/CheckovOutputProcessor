#!/bin/bash

function check_env_vars() {
  if [[ -z "$BC_API_KEY" ]]; then
    echo "Error: BC_API_KEY environment variable is not set. Please set it and try again."
    exit 1
  fi
}

function show_help() {
  echo "Usage: $0 [-p PACKAGE_FILTER] -d DOCKER_IMAGE -r REPO_ID -f DOCKERFILE_PATH [optional arguments]"
  echo
  echo "Environment Variables:"
  echo "  BC_API_KEY            Prisma Cloud API key (required)"
  echo
  echo "Required Arguments:"
  echo "  -d DOCKER_IMAGE       Docker image for the Checkov scan (e.g., 'python:3.9.20')"
  echo "  -r REPO_ID            Repository ID for the Checkov scan (e.g., 'oznetnerd/python')"
  echo "  -f DOCKERFILE_PATH    Path to the Dockerfile (e.g., './Dockerfile')"
  echo
  echo "Optional Arguments:"
  echo "  -p PACKAGE_FILTER     Specify the package type (e.g., 'os'). Default is all package types"
  echo "  -s STATUS_FILTER      Filter status (e.g., '^fixed')"
  echo "  -v SEVERITY_FILTER    Minimum severity level (e.g., 'medium', 'high')"
  echo "  -c CVSS_FILTER        Minimum CVSS score (e.g., 7.0)"
  echo "  -u                    Print raw, unfiltered JSON output (default: false)"
  echo
  echo "Example:"
  echo "  $0 -d python:3.9.20 -r oznetnerd/python -f ./Dockerfile -s '^fixed' -v high -c 7.0"
  exit 1
}

function check_required_args() {
  local missing_args=()
  [[ -z "$DOCKER_IMAGE" ]] && missing_args+=("-d DOCKER_IMAGE")
  [[ -z "$REPO_ID" ]] && missing_args+=("-r REPO_ID")
  [[ -z "$DOCKERFILE_PATH" ]] && missing_args+=("-f DOCKERFILE_PATH")

  if [[ ${#missing_args[@]} -ne 0 ]]; then
    echo "Error: Missing required arguments: ${missing_args[*]}"
    show_help
  fi
}

function parse_arguments() {
  RAW_OUTPUT=false
  CVSS_FILTER="null"
  while getopts ":p:s:v:c:d:r:f:uh" opt; do
    case ${opt} in
    p) PACKAGE_FILTER="$OPTARG" ;;
    s) STATUS_FILTER="$OPTARG" ;;
    v) SEVERITY_FILTER="$OPTARG" ;;
    c) CVSS_FILTER="$OPTARG" ;;
    d) DOCKER_IMAGE="$OPTARG" ;;
    r) REPO_ID="$OPTARG" ;;
    f) DOCKERFILE_PATH="$OPTARG" ;;
    u) RAW_OUTPUT=true ;;
    h) show_help ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      show_help
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      show_help
      ;;
    esac
  done
}

function display_filters() {
  CVSS_DISPLAY_VALUE="none"

  if [[ -n "$CVSS_FILTER" && "$CVSS_FILTER" != "null" ]]; then
    CVSS_DISPLAY_VALUE="$CVSS_FILTER"
  fi

  echo "Applying the following filters to the output:"
  echo "  PACKAGE_FILTER: ${PACKAGE_FILTER:-all}"
  echo "  STATUS_FILTER: ${STATUS_FILTER:-none}"
  echo "  SEVERITY_FILTER: ${SEVERITY_FILTER:-none}"
  echo "  CVSS_FILTER: $CVSS_DISPLAY_VALUE"
  echo "  RAW_OUTPUT: $RAW_OUTPUT"
  echo
}

function run_checkov() {
  echo "Running Checkov with the following command:"
  echo "checkov --docker-image \"$DOCKER_IMAGE\" --dockerfile-path \"$DOCKERFILE_PATH\" --repo-id \"$REPO_ID\" --output json --framework all"

  CHECKOV_OUTPUT=$(checkov --docker-image "$DOCKER_IMAGE" --bc-api-key "$BC_API_KEY" --dockerfile-path "$DOCKERFILE_PATH" --repo-id "$REPO_ID" --output json --framework all 2>/dev/null)
}

function validate_json() {
  echo "$CHECKOV_OUTPUT" | jq empty || {
    echo "Error: Invalid JSON output from Checkov"
    exit 1
  }
}

function display_raw_output() {
  if $RAW_OUTPUT; then
    echo
    echo "Raw JSON output from Checkov:"
    echo "$CHECKOV_OUTPUT"
    exit 0
  fi
}

function process_json_results() {
  local output_file="checkov_output.json"

  if [[ ! -f "$output_file" ]]; then
    echo "$CHECKOV_OUTPUT" >"$output_file" || {
      echo "Error: Failed to write to $output_file."
      exit 1
    }
  fi

  if ! jq empty "$output_file"; then
    echo "Error: Invalid JSON output in $output_file."
    exit 1
  fi

  (
    printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" \
      "PUBLISHED_DATE" "TYPE" "PACKAGE" "VERSION" "LOWEST_FIXED_VER" "FIXED_VERSIONS" \
      "SEVERITY" "CVSS" "RISK_FACTORS" "CVE ID" "STATUS" "VECTOR" "LINK"

    jq --arg pkg_type "${PACKAGE_FILTER:-all}" \
      --arg status_filter "$STATUS_FILTER" \
      --arg severity_filter "$SEVERITY_FILTER" \
      --argjson cvss_filter "${CVSS_FILTER:-7.0}" -r '

      def severity_level(severity):
        if severity == "critical" then 3
        elif severity == "high" then 2
        elif severity == "medium" then 1
        elif severity == "low" then 0
        else -1 end;

      .results.failed_checks[]
      | select(.vulnerability_details != null)
      | select($pkg_type == "all" or .vulnerability_details.package_type == $pkg_type)
      | select(.vulnerability_details.status | test($status_filter))
      | select(($severity_filter == "" or severity_level(.vulnerability_details.severity) >= severity_level($severity_filter)))
      | select((.vulnerability_details.cvss != null) and (.vulnerability_details.cvss | tonumber) >= $cvss_filter)
      | [
          (.vulnerability_details.published_date | split("T")[0] // "N/A"),
          .vulnerability_details.package_type,
          .vulnerability_details.package_name,
          .vulnerability_details.package_version,
          (.vulnerability_details.lowest_fixed_version // "N/A"),
          (if .vulnerability_details.fixed_versions then (.vulnerability_details.fixed_versions | join(", ")) else "N/A" end),
          .vulnerability_details.severity,
          (.vulnerability_details.cvss // "N/A"),
          (if .vulnerability_details.risk_factors then (.vulnerability_details.risk_factors | join(", ")) else "N/A" end),
          .vulnerability_details.id,
          .vulnerability_details.status,
          (.vulnerability_details.vector // "N/A"),
          (.vulnerability_details.link // "N/A")
        ] | @tsv' "$output_file" || {
      echo "Error processing JSON with jq"
      exit 1
    }
  ) | column -t -s $'\t'
}
#
check_env_vars
parse_arguments "$@"
check_required_args
display_filters
run_checkov
validate_json
display_raw_output
process_json_results
