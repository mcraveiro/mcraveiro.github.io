#!/usr/bin/env bash
set -euo pipefail

SITE_ROOT="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$SITE_ROOT/build/output/site"
PORT="${PORT:-8000}"

usage() {
    echo "Usage: $0 [--compile] [--port PORT]"
    echo ""
    echo "  --compile   Build the site before serving"
    echo "  --port      Port to serve on (default: 8000)"
    exit 1
}

COMPILE=0
while [[ $# -gt 0 ]]; do
    case "$1" in
        --compile) COMPILE=1; shift ;;
        --port)    PORT="$2"; shift 2 ;;
        -h|--help) usage ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

if [[ $COMPILE -eq 1 ]]; then
    echo "Building site..."
    emacs -Q --script "$SITE_ROOT/.build-site.el"
fi

echo "Serving $BUILD_DIR on http://localhost:$PORT"
cd "$BUILD_DIR"
exec python3 -m http.server "$PORT"
