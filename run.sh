#!/bin/bash
OUTPUT="result_$(date +%Y%m%d_%H%M%S)"

docker run --rm \
  --shm-size=2g \
  -v "$(pwd):/app" \
  -v paddleocr-models:/root/.paddlex \
  paddleocr \
  ocr \
  -i "/app/KK_3.jpg" \
  --use_doc_orientation_classify False \
  --use_doc_unwarping False \
  --use_textline_orientation False \
  --ocr_version PP-OCRv5 \
  --save_path /app/"$OUTPUT"
