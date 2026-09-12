#!/bin/sh


ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)"


qmllint "$ROOT/shell/shell.qml" 2>&1 || exit 1

find "$ROOT/shell" -name '*.qml' -print0 |
    while IFS= read -r -d '' f; do
        qmllint "$f" 2>&1 || exit 1
    done

exit 0