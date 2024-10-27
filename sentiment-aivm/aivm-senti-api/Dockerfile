FROM python:3.12 AS aivm-senti-api

LABEL org.opencontainers.image.authors="docker@anton.io"
LABEL "com.example.vendor"="AnTal Inc."
LABEL version="0.1"
LABEL description="This text illustrates \
the usage of nillion's AI VM for sentiment."

# Install system dependencies including.
RUN apt-get update && \
    apt-get install -y nano && \
    apt-get clean -y && \
    pip install poetry && \
    rm -rf /var/lib/apt/lists/*

# Copy relevant sources intot the container.
COPY . /root/aivm-senti-api
WORKDIR /root/aivm-senti-api

# Install project dependencies.
RUN poetry install  --no-root

# Declare what port we serve on.
EXPOSE 8888

# Execute aivm-devnet in background and poetry run aivm-senti.
CMD ["sh", "-c", "poetry run aivm-devnet & poetry run aivm-senti-api"]
