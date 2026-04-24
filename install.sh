#!/usr/bin/env bash
# One-click install script for zrr1999/dotfiles (via yadm)
# Usage: bash <(curl -fsSL https://raw.githubusercontent.com/zrr1999/dotfiles/main/install.sh)

set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/zrr1999/dotfiles.git}"
YADM_URL="https://github.com/TheLocehiliosan/yadm/raw/master/yadm"
YADM_TMP_DIR=""
YADM_BIN=""

cleanup() {
  if [[ -n "$YADM_TMP_DIR" ]]; then
    rm -rf "$YADM_TMP_DIR"
  fi
}
trap cleanup EXIT

echo "==> Dotfiles one-click install (yadm)"
echo "==> Repo: $REPO_URL"
echo ""

# Prefer system curl; ensure we can download
if ! command -v curl &>/dev/null; then
  echo "Error: curl is required. Install curl and try again." >&2
  exit 1
fi

if ! command -v git &>/dev/null; then
  echo "Error: git is required for yadm clone. Install git and try again." >&2
  exit 1
fi

YADM_TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/yadm.XXXXXX")"
YADM_BIN="$YADM_TMP_DIR/yadm"
PATH="$YADM_TMP_DIR:$PATH"

echo "==> Downloading yadm..."
PATH="/usr/bin:/bin:$PATH" curl -fLo "$YADM_BIN" "$YADM_URL"
chmod a+x "$YADM_BIN"

echo "==> Cloning dotfiles with yadm..."
"$YADM_BIN" clone --no-bootstrap "$REPO_URL"

echo "==> Running yadm bootstrap..."
"$YADM_BIN" bootstrap

echo "==> Cleaning up..."
cleanup
trap - EXIT

echo ""
echo "==> Done. Restart your shell or run: exec \$SHELL"
