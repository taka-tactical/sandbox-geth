#!/bin/bash -e

SYSDIR=$(cd "$(dirname "$0")"; pwd | xargs dirname)
NETDIR="${SYSDIR}/privatenet"

if ! [ -f "${NETDIR}/genesis.json" ]; then
  echo "can not run geth: genesis.json not prepared"
  echo ""
  exit 1
fi

if ! [ -f "${NETDIR}/static-nodes.json" ]; then
  echo "can not run geth: static-nodes.json not found"
  echo ""
  exit 1
fi

echo ""
echo "All check passed (init process succeeded)."
echo ""

exit 0
