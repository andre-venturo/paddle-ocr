ARG BUILDPLATFORM=linux/amd64
FROM --platform=$BUILDPLATFORM python:3.10-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir paddlepaddle==3.2.2 paddleocr==3.4.0

ENV PADDLE_PDX_DISABLE_MODEL_SOURCE_CHECK=True

WORKDIR /app

ENTRYPOINT ["paddleocr"]
