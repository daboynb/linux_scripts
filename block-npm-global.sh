#!/bin/sh
BASHRC="${HOME}/.bashrc"

grep -q "Block npm install -g" "${BASHRC}" 2>/dev/null
if [ $? -eq 0 ]; then
  echo "Already configured."
  exit 0
fi

cat >> "${BASHRC}" <<'EOF'

# Block npm install -g / --global
npm() {
  for arg in "$@"; do
    if [ "$arg" = "-g" ] || [ "$arg" = "--global" ]; then
      echo "Error: global npm install is blocked. Use a local install instead."
      return 1
    fi
  done
  command npm "$@"
}
EOF
echo "Done: npm install -g is now blocked. Run 'source ~/.bashrc' to apply."
