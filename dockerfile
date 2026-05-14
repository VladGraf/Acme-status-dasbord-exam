FROM python:3.12-slim

ENV POETRY_VERSION=1.8.3
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN useradd --create-home --shell /bin/bash dashboard-appusr

RUN pip install --no-cache-dir poetry==$POETRY_VERSION

COPY pyproject.toml ./

RUN poetry config virtualenvs.create false \
    && poetry install --only main --no-root

COPY app.py ./

USER dashboard-appusr

EXPOSE 5000

CMD ["python", "app.py"]
