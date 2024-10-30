# Checkov Output Processer

This script enables users to apply custom filters Checkov Dockerfile scans. It supports the following filters:

* `PACKAGE_TYPE`

* `STATUS_FILTER`

* `SEVERITY_FILTER`

* `CVSS_FILTER`

They can be used individually or in combination with one another.

## Prerequisites

1. **Checkov**: Make sure Checkov is installed and accessible from your command line

2. **jq**: The `jq` command-line tool is required for JSON parsing

## Usage

```
./script.sh -p PACKAGE_TYPE -d DOCKER_IMAGE -r REPO_ID -f DOCKERFILE_PATH [optional arguments]
```

### Required Environment Variable

- `BC_API_KEY`: Set this environment variable to your Bridgecrew API key.

### Required Arguments

- `-p PACKAGE_TYPE`: Specify the package type (e.g., `os`, `python`, `go`)

- `-d DOCKER_IMAGE`: Docker image for the Checkov scan (e.g., `python:3.9.20`)

- `-r REPO_ID`: Repository ID for the Checkov scan (e.g., `oznetnerd/python-app`)

- `-f DOCKERFILE_PATH`: Path to the Dockerfile (e.g., `./Dockerfile`)

### Optional Arguments

- `-s STATUS_FILTER`: Filter based on status (e.g., `^fixed`, `open`).

- `-v SEVERITY_FILTER`: Minimum severity level (e.g., `medium`).

- `-c CVSS_FILTER`: Minimum CVSS score (e.g., `7.0`).

- `-u`: Print raw, unfiltered JSON output (default: `false`).

## Auth

```
export BC_API_KEY="your_api_key"
```

### OS Only Vulnerabilities
#### Command

This command displays only `os`-related vulnerabilities, excluding others such as `python` and `go`.

```
./processor.sh -p os -d python:3.9.20 -r oznetnerd/python -f ./Dockerfile
```

#### Output

```
Applying the following filters to the output:
  PACKAGE_TYPE: os
  STATUS_FILTER: none
  SEVERITY_FILTER: none
  CVSS_FILTER: none
  RAW_OUTPUT: false

Running Checkov with the following command:
checkov --docker-image "python:3.9.20" --dockerfile-path "./Dockerfile" --repo-id "oznetnerd/python" --output json --framework all
PUBLISHED_DATE  TYPE  PACKAGE     VERSION                  LOWEST_FIXED_VER      FIXED_VERSIONS        SEVERITY  CVSS  RISK_FACTORS  CVE ID          STATUS                     VECTOR                                        LINK
2023-12-08      os    libheif     1.15.1-1                 1.15.1.post1+deb12u1  1.15.1.post1+deb12u1  high      8.8   N/A           CVE-2023-49462  fixed in 1.15.1-1+deb12u1  CVSS:3.1/AV:N/AC:L/PR:N/UI:R/S:U/C:H/I:H/A:H  https://security-tracker.debian.org/tracker/CVE-2023-49462
2023-05-06      os    libheif     1.15.1-1                 1.15.1.post1+deb12u1  1.15.1.post1+deb12u1  medium    6.5   N/A           CVE-2023-29659  fixed in 1.15.1-1+deb12u1  CVSS:3.1/AV:N/AC:L/PR:N/UI:R/S:U/C:N/I:N/A:H  https://security-tracker.debian.org/tracker/CVE-2023-29659
2023-12-28      os    aom         3.6.0-1+deb12u1          N/A                                         low       9.8   N/A           CVE-2023-6879   open                       CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H  https://security-tracker.debian.org/tracker/CVE-2023-6879
2024-06-16      os    wget        1.21.3-1                 N/A                                         low       9.1   N/A           CVE-2024-38428  open                       CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:N  https://security-tracker.debian.org/tracker/CVE-2024-38428
2024-02-02      os    openexr     3.1.5-5                  N/A                                         low       9.1   N/A           CVE-2023-5841   open                       CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:N  https://security-tracker.debian.org/tracker/CVE-2023-5841
2023-04-29      os    perl        5.36.0-7+deb12u1         N/A                                         low       8.1   N/A           CVE-2023-31484  open                       CVSS:3.1/AV:N/AC:H/PR:N/UI:N/S:U/C:H/I:H/A:H  https://security-tracker.debian.org/tracker/CVE-2023-31484
2022-03-05      os    openjpeg2   2.5.0-2                  N/A                                         low       7.8   N/A           CVE-2021-3575   open                       CVSS:3.1/AV:L/AC:L/PR:N/UI:R/S:U/C:H/I:H/A:H  https://security-tracker.debian.org/tracker/CVE-2021-3575
2024-08-12      os    tiff        4.5.0-6+deb12u1          N/A                                         low       7.5   N/A           CVE-2024-7006   open                       CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H  https://security-tracker.debian.org/tracker/CVE-2024-7006
2024-02-05      os    libxml2     2.9.14+dfsg-1.3~deb12u1  N/A                                         low       7.5   N/A           CVE-2024-25062  open                       CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H  https://security-tracker.debian.org/tracker/CVE-2024-25062
2024-02-05      os    expat       2.5.0-1+deb12u1          N/A                                         low       7.5   N/A           CVE-2023-52425  open                       CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H  https://security-tracker.debian.org/tracker/CVE-2023-52425
2024-01-26      os    tiff        4.5.0-6+deb12u1          N/A                                         low       7.5   N/A           CVE-2023-52356  open                       CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H  https://security-tracker.debian.org/tracker/CVE-2023-52356
2023-05-31      os    openldap    2.5.13+dfsg-5            N/A                                         low       7.5   N/A           CVE-2023-2953   open                       CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H  https://security-tracker.debian.org/tracker/CVE-2023-2953
2023-02-05      os    harfbuzz    6.0.0+dfsg-3             N/A                                         low       7.5   N/A           CVE-2023-25193  open                       CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H  https://security-tracker.debian.org/tracker/CVE-2023-25193
2023-12-29      os    sqlite3     3.40.1-2                 N/A                                         low       7.3   N/A           CVE-2023-7104   open                       CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:L/A:L  https://security-tracker.debian.org/tracker/CVE-2023-7104
2023-12-13      os    ncurses     6.4-4                    N/A                                         low       6.5   N/A           CVE-2023-50495  open                       CVSS:3.1/AV:N/AC:L/PR:N/UI:R/S:U/C:N/I:N/A:H  https://security-tracker.debian.org/tracker/CVE-2023-50495
2023-07-13      os    tiff        4.5.0-6+deb12u1          N/A                                         low       6.5   N/A           CVE-2023-3618   open                       CVSS:3.1/AV:N/AC:L/PR:N/UI:R/S:U/C:N/I:N/A:H  https://security-tracker.debian.org/tracker/CVE-2023-3618
2021-04-29      os    wget        1.21.3-1                 N/A                                         low       6.1   N/A           CVE-2021-31879  open                       CVSS:3.1/AV:N/AC:L/PR:N/UI:R/S:C/C:L/I:L/A:N  https://security-tracker.debian.org/tracker/CVE-2021-31879
2023-05-10      os    dav1d       1.0.0-2+deb12u1          N/A                                         low       5.9   N/A           CVE-2023-32570  open                       CVSS:3.1/AV:N/AC:H/PR:N/UI:N/S:U/C:N/I:N/A:H  https://security-tracker.debian.org/tracker/CVE-2023-32570
2024-02-06      os    pam         1.5.2-6+deb12u1          N/A                                         low       5.5   N/A           CVE-2024-22365  open                       CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:N/I:N/A:H  https://security-tracker.debian.org/tracker/CVE-2024-22365
2023-12-28      os    shadow      1:4.13+dfsg1-1           N/A                                         low       5.5   N/A           CVE-2023-4641   open                       CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:N  https://security-tracker.debian.org/tracker/CVE-2023-4641
2023-07-01      os    tiff        4.5.0-6+deb12u1          N/A                                         low       5.5   N/A           CVE-2023-2908   open                       CVSS:3.1/AV:L/AC:L/PR:N/UI:R/S:U/C:N/I:N/A:H  https://security-tracker.debian.org/tracker/CVE-2023-2908
2023-06-30      os    tiff        4.5.0-6+deb12u1          N/A                                         low       5.5   N/A           CVE-2023-26966  open                       CVSS:3.1/AV:L/AC:L/PR:N/UI:R/S:U/C:N/I:N/A:H  https://security-tracker.debian.org/tracker/CVE-2023-26966
2023-06-15      os    tiff        4.5.0-6+deb12u1          N/A                                         low       5.5   N/A           CVE-2023-26965  open                       CVSS:3.1/AV:L/AC:L/PR:N/UI:R/S:U/C:N/I:N/A:H  https://security-tracker.debian.org/tracker/CVE-2023-26965
2023-06-30      os    tiff        4.5.0-6+deb12u1          N/A                                         low       5.5   N/A           CVE-2023-25433  open                       CVSS:3.1/AV:L/AC:L/PR:N/UI:R/S:U/C:N/I:N/A:H  https://security-tracker.debian.org/tracker/CVE-2023-25433
2023-04-19      os    python3.11  3.11.2-6+deb12u3         N/A                                         low       5.3   N/A           CVE-2023-27043  open                       CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:L/A:N  https://security-tracker.debian.org/tracker/CVE-2023-27043
2024-04-17      os    mariadb     1:10.11.6-0+deb12u1      N/A                                         low       4.9   N/A           CVE-2024-21096  open                       CVSS:3.1/AV:L/AC:H/PR:N/UI:N/S:U/C:L/I:L/A:L  https://security-tracker.debian.org/tracker/CVE-2024-21096
2023-08-02      os    procps      2:4.0.2-3                N/A                                         low       3.3   N/A           CVE-2023-4016   open                       CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:N/I:N/A:L  https://security-tracker.debian.org/tracker/CVE-2023-4016
2023-04-15      os    shadow      1:4.13+dfsg1-1           N/A                                         low       3.3   N/A           CVE-2023-29383  open                       CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:N/I:L/A:N  https://security-tracker.debian.org/tracker/CVE-2023-29383
```

### Medium or Higher with Fix Available
#### Command

In addition to filtering results to show only `os`-related vulnerabilities, this command also shows only `medium` or higher vulnerabilities where the `STATUS` field starts with `fixed`:

```
./processor.sh -p os -d python:3.9.20 -r oznetnerd/python -f ./Dockerfile -v medium -s '^fixed'
```

#### Output

```
Applying the following filters to the output:
  PACKAGE_TYPE: os
  STATUS_FILTER: ^fixed
  SEVERITY_FILTER: medium
  CVSS_FILTER: none
  RAW_OUTPUT: false

PUBLISHED_DATE  TYPE  PACKAGE  VERSION   LOWEST_FIXED_VER      FIXED_VERSIONS        SEVERITY  CVSS  RISK_FACTORS  CVE ID          STATUS                     VECTOR                                        LINK
2023-12-08      os    libheif  1.15.1-1  1.15.1.post1+deb12u1  1.15.1.post1+deb12u1  high      8.8   N/A           CVE-2023-49462  fixed in 1.15.1-1+deb12u1  CVSS:3.1/AV:N/AC:L/PR:N/UI:R/S:U/C:H/I:H/A:H  https://security-tracker.debian.org/tracker/CVE-2023-49462
2023-05-06      os    libheif  1.15.1-1  1.15.1.post1+deb12u1  1.15.1.post1+deb12u1  medium    6.5   N/A           CVE-2023-29659  fixed in 1.15.1-1+deb12u1  CVSS:3.1/AV:N/AC:L/PR:N/UI:R/S:U/C:N/I:N/A:H  https://security-tracker.debian.org/tracker/CVE-2023-29659
```

### All Vulnerabilities with Fix Available
#### Command

Similar to the previous command, this command shows only `medium` or higher vulnerabilities where the `STATUS` field starts with `fixed`. However, as the `-p` flag has not been used, it is showing all `PACKAGE TYPE`s:

```
./processor.sh -d python:3.9.20 -r oznetnerd/python -f ./Dockerfile -s '^fixed'
```

#### Output

```
Applying the following filters to the output:
  PACKAGE_FILTER: all
  STATUS_FILTER: ^fixed
  SEVERITY_FILTER: none
  CVSS_FILTER: none
  RAW_OUTPUT: false

PUBLISHED_DATE  TYPE    PACKAGE     VERSION   LOWEST_FIXED_VER      FIXED_VERSIONS        SEVERITY  CVSS  RISK_FACTORS  CVE ID          STATUS                     VECTOR                                        LINK
2024-07-15      python  setuptools  58.1.0    70.0.0                70.0.0                high      8.8   N/A           CVE-2024-6345   fixed in 70.0.0            N/A                                           https://nvd.nist.gov/vuln/detail/CVE-2024-6345
2023-12-08      os      libheif     1.15.1-1  1.15.1.post1+deb12u1  1.15.1.post1+deb12u1  high      8.8   N/A           CVE-2023-49462  fixed in 1.15.1-1+deb12u1  CVSS:3.1/AV:N/AC:L/PR:N/UI:R/S:U/C:H/I:H/A:H  https://security-tracker.debian.org/tracker/CVE-2023-49462
2023-05-06      os      libheif     1.15.1-1  1.15.1.post1+deb12u1  1.15.1.post1+deb12u1  medium    6.5   N/A           CVE-2023-29659  fixed in 1.15.1-1+deb12u1  CVSS:3.1/AV:N/AC:L/PR:N/UI:R/S:U/C:N/I:N/A:H  https://security-tracker.debian.org/tracker/CVE-2023-29659
2022-12-23      python  setuptools  58.1.0    65.5.1                65.5.1                medium    5.9   N/A           CVE-2022-40897  fixed in 65.5.1            CVSS:3.1/AV:N/AC:H/PR:N/UI:N/S:U/C:N/I:N/A:H  https://nvd.nist.gov/vuln/detail/CVE-2022-40897
2023-10-26      python  pip         23.0.1    23.3                  23.3                  low       3.3   N/A           CVE-2023-5752   fixed in 23.3              CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:N/I:L/A:N  https://nvd.nist.gov/vuln/detail/CVE-2023-5752
```