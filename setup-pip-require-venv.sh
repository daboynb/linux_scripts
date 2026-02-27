#!/bin/sh
PIP_CONF_FILE="/etc/pip.conf"

cat > "${PIP_CONF_FILE}" <<'EOF'
[global]
require-virtualenv = true
EOF
echo "Done: pip install is now blocked outside a virtualenv."
