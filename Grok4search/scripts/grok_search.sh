#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSETS_DIR="${SCRIPT_DIR}/../assets"
ENV_FILE="${ASSETS_DIR}/.env"
CONFIG_FILE="${ASSETS_DIR}/config.json"

if [[ $# -lt 1 ]]; then
  echo "Usage: bash scripts/grok_search.sh \"your query\"" >&2
  exit 1
fi

QUERY="$1"

load_env_file() {
  if [[ ! -f "${ENV_FILE}" ]]; then
    return
  fi

  while IFS='=' read -r key value; do
    [[ -z "${key}" ]] && continue
    [[ "${key}" =~ ^[[:space:]]*# ]] && continue
    key="${key%%[[:space:]]*}"
    value="${value%$'\r'}"

    case "${key}" in
      GROK_BASE_URL)
        [[ -z "${GROK_BASE_URL:-}" ]] && GROK_BASE_URL="${value}"
        ;;
      GROK_API_KEY)
        [[ -z "${GROK_API_KEY:-}" ]] && GROK_API_KEY="${value}"
        ;;
      GROK_MODEL)
        [[ -z "${GROK_MODEL:-}" ]] && GROK_MODEL="${value}"
        ;;
    esac
  done < "${ENV_FILE}"
}

read_config() {
  if [[ ! -f "${CONFIG_FILE}" ]]; then
    return
  fi

  node -e '
const fs = require("fs");
const path = process.argv[1];
const key = process.argv[2];
const data = JSON.parse(fs.readFileSync(path, "utf8"));
process.stdout.write(String(data[key] ?? ""));
' "${CONFIG_FILE}" "$1"
}

load_env_file

FILE_BASE_URL="$(read_config base_url)"
FILE_API_KEY="$(read_config api_key)"
FILE_MODEL="$(read_config model)"

BASE_URL="${GROK_BASE_URL:-$FILE_BASE_URL}"
API_KEY="${GROK_API_KEY:-$FILE_API_KEY}"
MODEL="${GROK_MODEL:-${FILE_MODEL:-grok-4}}"

if [[ -z "${BASE_URL}" || -z "${API_KEY}" ]]; then
  echo "Grok4search 还没有可用配置。" >&2
  echo "请先填写以下任一文件：" >&2
  echo "1. assets/.env" >&2
  echo "2. assets/config.json" >&2
  echo "" >&2
  echo "至少需要：" >&2
  echo "- GROK_BASE_URL" >&2
  echo "- GROK_API_KEY" >&2
  echo "" >&2
  echo "可选：" >&2
  echo "- GROK_MODEL，默认 grok-4" >&2
  exit 1
fi

BASE_URL="${BASE_URL%/}"

RESPONSE="$(curl -sS "${BASE_URL}/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${API_KEY}" \
  -d "$(node -e '
const payload = {
  model: process.argv[1] || "grok-4",
  messages: [
    {
      role: "system",
      content: "You only perform web search through Grok and return concise search results with sources, dates when available, and explicit uncertainty."
    },
    {
      role: "user",
      content: process.argv[2]
    }
  ],
  temperature: 0.2
};
process.stdout.write(JSON.stringify(payload));
' "${MODEL:-grok-4}" "${QUERY}")")" || {
  echo "Grok 请求失败。请检查 base_url、api_key、model 以及接口是否兼容 /chat/completions。" >&2
  exit 1
}

if [[ -z "${RESPONSE}" ]]; then
  echo "Grok 请求失败：接口返回了空响应。" >&2
  exit 1
fi

printf '%s\n' "${RESPONSE}"
