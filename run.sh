#!/bin/bash
OUTPUT="result_$(date +%Y%m%d_%H%M%S)"

docker run --rm \
  --shm-size=2g \
  -v "$(pwd):/app" \
  -v paddleocr-models:/root/.paddlex \
  paddleocr \
  ocr \
  -i "/app/Screenshot 2026-02-04 at 13.43.55.png" \
  --use_doc_orientation_classify False \
  --use_doc_unwarping False \
  --use_textline_orientation False \
  --ocr_version PP-OCRv5 \
  --save_path /app/"$OUTPUT"
