
# Stage 1: Builder

FROM python:3.10-slim AS builder

# Install build tools (removed from final image)
RUN apt-get update && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements and install dependencies into a separate prefix directory
COPY requirements.txt /app/
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Copy the rest of the application code into the builder
COPY . /app


# Stage 2: Final

FROM python:3.10-slim

# Create a non-root user
RUN adduser --disabled-password --gecos '' appuser

# Set working directory and switch ownership
WORKDIR /app
USER appuser

# Copy pre-installed site-packages from builder stage
COPY --from=builder /install /usr/local

# Copy application code
COPY --chown=appuser:appuser . /app

# Expose the port
EXPOSE 443

# Run the application as non-root
CMD ["python", "counter-service.py"]
