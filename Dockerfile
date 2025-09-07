FROM python:3.12-slim AS builder

ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN pip install poetry
COPY pyproject.toml poetry.lock ./
RUN poetry install --no-root

FROM python:3.12-slim

WORKDIR /app

ENV PYTHONPATH=/app

COPY --from=builder /app/.venv .venv
ENV PATH="/app/.venv/bin:$PATH"

COPY ./app ./app

COPY .env app/data/sys/.env

CMD ["python", "app/main.py", "-launch_bot", "--name=Test"]