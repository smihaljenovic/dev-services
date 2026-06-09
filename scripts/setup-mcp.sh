#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "==> dev-services MCP setup"
echo ""

# Node.js (required for MySQL, Postgres, MongoDB, Elasticsearch)
if ! command -v node >/dev/null 2>&1; then
  echo "ERROR: Node.js is required (>= 22.13). Install via nvm or nodejs.org." >&2
  exit 1
fi

NODE_MAJOR="$(node -p "process.versions.node.split('.')[0]")"
if [[ "$NODE_MAJOR" -lt 22 ]]; then
  echo "WARNING: Node $(node -v) detected. MongoDB MCP recommends Node >= 22.13." >&2
fi

echo "Node: $(node -v)"
echo ""

# uv / uvx (required for official Redis MCP — Python)
if ! command -v uvx >/dev/null 2>&1; then
  echo "==> Installing uv (provides uvx for official Redis MCP)..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="${HOME}/.local/bin:${PATH}"
fi

if command -v uvx >/dev/null 2>&1; then
  echo "uvx: $(command -v uvx)"
  echo "==> Prefetching official Redis MCP server..."
  uvx --from redis-mcp-server@latest redis-mcp-server --help >/dev/null 2>&1 || true
else
  echo "WARNING: uvx still not on PATH. Add ~/.local/bin to your shell profile." >&2
fi

echo ""

# npm packages (official / de-facto standard JS/TS servers)
echo "==> Installing MCP npm packages..."
npm install --prefix "$ROOT/mcp"

echo ""
echo "==> Making launcher scripts executable..."
chmod +x "$ROOT/mcp/bin/"*

echo ""
echo "Done. MCP servers:"
echo "  mysql_dev          @benborla29/mcp-server-mysql (community standard)"
echo "  postgres_dev       @modelcontextprotocol/server-postgres (MCP official)"
echo "  mongo_dev          mongodb-mcp-server (MongoDB official)"
echo "  elasticsearch_dev  @elastic/mcp-server-elasticsearch (Elastic official)"
echo "  redis_dev          redis-mcp-server (Redis official, Python via uvx)"
echo ""
echo "Start Docker services, then reload MCP in Cursor:"
echo "  docker compose up -d mysql_dev postgres_dev redis_dev mongo_dev elasticsearch_dev"
