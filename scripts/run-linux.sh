#!/usr/bin/env bash

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_ROOT"

echo
echo "======================================"
echo "          Insta UI Lab"
echo "             DEMO ONLY"
echo "======================================"
echo

read -rp "Enter redirect URL: " REDIRECT_URL

if [[ -z "$REDIRECT_URL" ]]; then
    REDIRECT_URL="https://example.com"
fi

if [[ ! "$REDIRECT_URL" =~ ^https?:// ]]; then
    echo
    echo "[!] Invalid URL."
    echo "[!] URL must start with http:// or https://"
    exit 1
fi

echo
echo "[+] Redirect URL:"
echo "    $REDIRECT_URL"
echo

if [[ ! -d ".venv" ]]; then

    echo "[+] Creating virtual environment..."

    python3 -m venv .venv

fi

source .venv/bin/activate

echo "[+] Installing dependencies..."

python -m pip install --upgrade pip

python -m pip install -r requirements.txt

export REDIRECT_URL

echo
echo "[+] Starting Flask server..."
echo
echo "[+] Local:"
echo "    http://127.0.0.1:5000"
echo

python app.py &

SERVER_PID=$!


cleanup() {

    echo
    echo "[+] Stopping server..."

    kill "$SERVER_PID" 2>/dev/null || true

}

trap cleanup EXIT INT TERM


sleep 2


if command -v ngrok >/dev/null 2>&1; then

    echo
    read -rp "Start ngrok tunnel? [y/N]: " USE_NGROK

    if [[ "$USE_NGROK" =~ ^[Yy]$ ]]; then

        echo
        echo "[+] Starting ngrok..."
        echo "[+] Exposing localhost demo only."
        echo

        ngrok http 5000

    else

        echo
        echo "[+] Localhost mode."
        echo

        wait "$SERVER_PID"

    fi

else

    echo
    echo "[i] ngrok is not installed."
    echo "[i] Running localhost mode."
    echo

    wait "$SERVER_PID"

fi
