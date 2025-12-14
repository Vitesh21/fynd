# Multi-stage build for AI Feedback System Backend
FROM python:3.11-slim

WORKDIR /app

# Copy backend requirements
COPY backend/requirements_prod.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements_prod.txt

# Copy backend code
COPY backend/ .

# Expose port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:5000/api/health')" || exit 1

# Run gunicorn
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app_prod:app"]
