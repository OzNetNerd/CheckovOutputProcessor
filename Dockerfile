# Use the official Python 3.9.20 image from the Docker Hub
FROM python:3.9.20

# Set the working directory
WORKDIR /app

# Copy your application files
COPY . /app

# Install any dependencies (if you have a requirements.txt file)
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 80 (or another port your app runs on)
EXPOSE 80

# Start your application (replace `app.py` with your main application file)
CMD ["python", "app.py"]

