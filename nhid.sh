#!/usr/bin/env bash

for host_dir in hosts/*/; do
    host=$(basename "$host_dir")
    config_file="${host_dir}configuration.nix"

    if [[ -f "$config_file" ]]; then
        # 1. Alte hostId-Einträge restlos aus der Datei löschen
        sed -i '/networking\.hostId/d' "$config_file"

        # 2. Neue ID bestimmen
        if [[ "$host" == "peano" ]]; then
            host_id="8f3c7b2a"
        else
            host_id=$(echo -n "$host" | sha256sum | cut -c 1-8)
        fi

        # 3. Neue statische hostId direkt unter hostName einfügen
        sed -i "/networking\.hostName/a \  networking.hostId = \"$host_id\";" "$config_file"

        echo "[OK] $host aktualisiert -> hostId = \"$host_id\""
    fi
done
