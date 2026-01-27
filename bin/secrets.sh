#!/usr/bin/env bash
set -euo pipefail

# Usage for dev environment:
#   ./secrets.sh dev decrypt
#   ./secrets.sh dev encrypt

ENVIRONMENT="${1:-}"
ACTION="${2:-}"

if [[ -z "$ENVIRONMENT" || -z "$ACTION" ]]; then
    echo "Usage: $0 <environment> <decrypt|encrypt>"
    exit 1
fi

SECRET="./env/$ENVIRONMENT/secrets.sops.yaml"
PLAIN="./env/$ENVIRONMENT/local.secrets.yaml"

case "$ACTION" in
    decrypt)
        if [[ ! -f "$SECRET" ]]; then
            echo "Error: $SECRET does not exist."
            exit 1
        fi

        echo "Decrypting $SECRET → $PLAIN"
        sops --decrypt "$SECRET" > "$PLAIN"
        ;;

    encrypt)
        if [[ ! -f "$PLAIN" ]]; then
            echo "Error: $PLAIN does not exist. Run decrypt first."
            exit 1
        fi

        echo "Encrypting $PLAIN → $SECRET"
        sops --encrypt "$PLAIN" > "$SECRET"

        # remove plaintext after successful encrypt
        rm -f "$PLAIN"
        echo "Removed plaintext file: $PLAIN"
        ;;

    *)
        echo "Invalid action: $ACTION"
        echo "Expected: decrypt or encrypt"
        exit 1
        ;;
esac