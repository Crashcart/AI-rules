FROM python:3.11-slim

WORKDIR /app

# Install PyYAML (only external dep — broker itself uses stdlib only)
RUN pip install --no-cache-dir pyyaml

COPY pipeline/ ./pipeline/

EXPOSE 4242

CMD ["python", "-m", "pipeline.broker", "--host", "0.0.0.0", "--port", "4242"]
