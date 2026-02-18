@echo off
setlocal enabledelayedexpansion

set IMAGE_NAME=paddleocr-gpu
set INPUT_FILE=%~1
set OCR_VERSION=%~2

if "%OCR_VERSION%"=="" set OCR_VERSION=PP-OCRv5

if "%INPUT_FILE%"=="" (
    echo Usage: %~nx0 ^<input_image^> [PP-OCRv5^|PP-OCRv4]
    echo.
    echo Examples:
    echo   %~nx0 my_image.png              # PP-OCRv5 ^(default^)
    echo   %~nx0 my_image.png PP-OCRv4     # PP-OCRv4
    echo   %~nx0 https://example.com/img.png # URL input
    exit /b 1
)

:: Generate timestamped output folder
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set DT=%%I
set OUTPUT=result_%DT:~0,8%_%DT:~8,6%

:: Build image if not present
docker image inspect %IMAGE_NAME% >nul 2>&1
if errorlevel 1 (
    echo Building %IMAGE_NAME%...
    docker build -f Dockerfile.gpu -t %IMAGE_NAME% .
)

:: Determine if input is a URL or local file
echo %INPUT_FILE% | findstr /r "^https*://" >nul 2>&1
if errorlevel 1 (
    for %%F in ("%INPUT_FILE%") do set INPUT_ARG=/app/%%~nxF
) else (
    set INPUT_ARG=%INPUT_FILE%
)

docker run --rm ^
    --gpus all ^
    --shm-size=2g ^
    -v "%cd%:/app" ^
    -v paddleocr-models:/root/.paddlex ^
    %IMAGE_NAME% ^
    ocr ^
    -i "%INPUT_ARG%" ^
    --enable_hpi True ^
    --use_doc_orientation_classify False ^
    --use_doc_unwarping False ^
    --use_textline_orientation False ^
    --ocr_version %OCR_VERSION% ^
    --device gpu:0 ^
    --save_path /app/%OUTPUT%

echo Results saved to .\%OUTPUT%
