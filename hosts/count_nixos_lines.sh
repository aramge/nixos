#!/usr/bin/env bash

# Findet alle configuration.nix Dateien, liest deren Inhalt,
# entfernt führende und nachfolgende Leerzeichen (für besseres Matching),
# filtert Leerzeilen und reine Kommentare heraus,
# und zählt die Vorkommen absteigend sortiert.

find . -name "configuration.nix" -type f -exec cat {} + | \
  sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | \
  grep -Ev '^#|^$' | \
  sort | \
  uniq -c | \
  sort -nr
