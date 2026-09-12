#!/bin/sh

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)"
yaml_pkgs="$(sed -n '/^runtime:/,/^[a-z_]*:/p' "$ROOT/dependency-manifest.yaml" | grep '^  - ' | sed 's/^  - *//; s/ *#.*$//' | grep -v '^\s*$' | sort)"
lib_pkgs="$(awk '/^runtime:/,/^[a-z_]*:/' "$ROOT/installer/lib.sh" 2>/dev/null || true)"


[ -n "$yaml_pkgs" ] || { echo "manifest empty or malformed"; exit 1; }
echo "parsed $(echo "$yaml_pkgs" | wc -l) runtime packages from dependency-manifest.yaml"
exit 0