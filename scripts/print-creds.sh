#!/usr/bin/env bash
set -euo pipefail
ENV_DIR="${1:-envs/dev}"
CMD=$(cd "$ENV_DIR" && terraform output -raw get_credentials_cmd)
echo "$CMD"
eval "$CMD"
