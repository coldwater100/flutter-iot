FROM python:3.9-slim

WORKDIR /app

COPY pyproject.toml ./
COPY src/ ./src

RUN pip install --upgrade pip && pip install .

CMD ["python", "src/main.py"]
