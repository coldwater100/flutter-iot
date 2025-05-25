FROM python:3.9-slim

WORKDIR /app

# Copy project metadata
COPY pyproject.toml ./

# Copy source code first to avoid 'src missing' error
COPY src/ ./src

# Install dependencies
RUN pip install --upgrade pip \
    && pip install .

# Optional: copy test or other files if needed
COPY tests/ ./tests

EXPOSE 8000

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
