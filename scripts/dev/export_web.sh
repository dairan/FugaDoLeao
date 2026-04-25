#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
GODOT="/Applications/Godot.app/Contents/MacOS/Godot"
BUILD_DIR="$PROJECT_DIR/build/web"
SERVE="$PROJECT_DIR/build/serve.py"
PORT=8080

echo "→ Exportando para Web..."
mkdir -p "$BUILD_DIR"
"$GODOT" --headless --path "$PROJECT_DIR" --export-release "Web" "$BUILD_DIR/index.html"

echo "→ Reiniciando servidor local..."
lsof -ti ":$PORT" | xargs kill -9 2>/dev/null || true
sleep 1
python3 "$SERVE" &>/tmp/godot_web_server.log &

sleep 1
echo "→ Abrindo http://localhost:$PORT"
open -a "Google Chrome" "http://localhost:$PORT"
