#!/usr/bin/env bash
# Cursor GUI apps on macOS get a minimal PATH — resolve node/uvx explicitly.
export PATH="${HOME}/.local/bin:/opt/homebrew/bin:/usr/local/bin:${PATH:-/usr/bin:/bin}"

if [[ -d "${HOME}/.nvm/versions/node" ]]; then
  for dir in "${HOME}"/.nvm/versions/node/*/bin; do
    [[ -d "$dir" ]] && PATH="${dir}:${PATH}"
  done
fi

if [[ -s "${HOME}/.nvm/nvm.sh" ]]; then
  # shellcheck disable=SC1091
  source "${HOME}/.nvm/nvm.sh" --no-use 2>/dev/null || true
fi

export PATH

if [[ -z "${NODE:-}" ]]; then
  NODE="$(command -v node 2>/dev/null || true)"
  if [[ -z "$NODE" && -x "/opt/homebrew/bin/node" ]]; then
    NODE="/opt/homebrew/bin/node"
  fi
  export NODE
fi

if [[ -z "${NODE:-}" ]]; then
  echo "node not found. Run: ./scripts/setup-mcp.sh" >&2
  exit 1
fi
