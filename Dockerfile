FROM python:3.10-slim

# Create app directory
WORKDIR /app

# Copy requirements and install
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY . /app

# Expose the port used by the app (adjust if needed)
EXPOSE 443

# Run the application
CMD ["python", "counter-service.py"]
