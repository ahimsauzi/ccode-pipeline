#!/bin/bash
# Generate PNG from all .mmd files in src/
# Output goes to output/ as PNG
# Usage: ./generate.sh
# Usage (single file): ./generate.sh src/my-diagram.mmd

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$SCRIPT_DIR/src"
OUT="$SCRIPT_DIR/output"

if ! command -v mmdc &> /dev/null; then
    echo "mermaid-cli not found. Run: npm install -g @mermaid-js/mermaid-cli"
    exit 1
fi

if [ -n "$1" ]; then
    # Single file mode
    FILE="$1"
    BASENAME=$(basename "$FILE" .mmd)
    mmdc -i "$FILE" -o "$OUT/$BASENAME.png" -c "$SCRIPT_DIR/mermaid-config.json" --backgroundColor white --scale 3
    echo "Generated: $OUT/$BASENAME.png"
else
    # Batch mode: all .mmd files in src/
    COUNT=0
    for FILE in "$SRC"/*.mmd; do
        [ -f "$FILE" ] || continue
        BASENAME=$(basename "$FILE" .mmd)
        mmdc -i "$FILE" -o "$OUT/$BASENAME.png" -c "$SCRIPT_DIR/mermaid-config.json" --backgroundColor white --scale 3
        echo "Generated: $OUT/$BASENAME.png"
        COUNT=$((COUNT + 1))
    done
    echo "Done. $COUNT diagram(s) generated."
fi
