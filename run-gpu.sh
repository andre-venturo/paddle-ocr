#!/bin/bash
set -e

IMAGE_NAME="paddleocr-gpu"
OUTPUT="result_$(date +%Y%m%d_%H%M%S)"
INPUT_FILE="${1:-}"
OCR_VERSION="${2:-PP-OCRv5}"

usage() {
    echo "Usage: $0 <input_image> [PP-OCRv5|PP-OCRv4]"
    echo ""
    echo "Examples:"
    echo "  $0 ./my_image.png              # PP-OCRv5 (default)"
    echo "  $0 ./my_image.png PP-OCRv4     # PP-OCRv4"
    echo "  $0 https://example.com/img.png # URL input"
    exit 1
}

if [ -z "$INPUT_FILE" ]; then
    usage
fi

# Build image if not present
if ! docker image inspect "$IMAGE_NAME" &>/dev/null; then
    echo "Building $IMAGE_NAME..."
    docker build -f Dockerfile.gpu -t "$IMAGE_NAME" .
fi

# Determine if input is a URL or local file
if [[ "$INPUT_FILE" =~ ^https?:// ]]; then
    INPUT_ARG="$INPUT_FILE"
else
    INPUT_ARG="/app/$(basename "$INPUT_FILE")"
fi

docker run --rm \
    --gpus all \
    --shm-size=2g \
    -v "$(pwd):/app" \
    -v paddleocr-models:/root/.paddlex \
    "$IMAGE_NAME" \
    ocr \
    -i "$INPUT_ARG" \
    --enable_hpi True \
    --use_doc_orientation_classify False \
    --use_doc_unwarping False \
    --use_textline_orientation False \
    --ocr_version "$OCR_VERSION" \
    --device gpu:0 \
    --save_path /app/"$OUTPUT"

echo "Results saved to ./$OUTPUT"
