# paddle-ocr

OCR inference using PaddleOCR 3.4.0 with PP-OCRv5 in Docker.

## CPU

### Build

```bash
docker build -t paddleocr .
```

### Usage

Place your image in the project directory, then run:

```bash
./run.sh
```

Results are saved to a timestamped `result_YYYYMMDD_HHMMSS/` directory.

## GPU (NVIDIA)

Uses the official PaddleX image with CUDA 11.8 + cuDNN 8.9 + TensorRT 8.6 for high-performance inference.

### Prerequisites

- NVIDIA GPU with driver installed
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

### Build

```bash
docker build -f Dockerfile.gpu -t paddleocr-gpu .
```

### Usage

```bash
# PP-OCRv5 (default, highest accuracy)
./run-gpu.sh ./my_image.png

# PP-OCRv4
./run-gpu.sh ./my_image.png PP-OCRv4

# URL input
./run-gpu.sh https://paddle-model-ecology.bj.bcebos.com/paddlex/imgs/demo_image/general_ocr_002.png
```

The image is built automatically on first run if not present.

## Flags

| Flag | Description |
|------|-------------|
| `--enable_hpi True` | Enable high-performance inference (TensorRT + FP16) |
| `--device gpu:0` | Target GPU device |
| `--ocr_version PP-OCRv5` | Use PP-OCRv5 models (default) |
| `--ocr_version PP-OCRv4` | Use PP-OCRv4 models |
| `--use_doc_orientation_classify False` | Skip document orientation detection |
| `--use_doc_unwarping False` | Skip document unwarping |
| `--use_textline_orientation False` | Skip textline orientation detection |
| `--save_path` | Output directory for results |

## Docker flags

| Flag | Description |
|------|-------------|
| `--gpus all` | Expose all GPUs to the container |
| `--shm-size=2g` | Required shared memory for PaddlePaddle |
| `-v paddleocr-models:/root/.paddlex` | Persist downloaded models across runs |
