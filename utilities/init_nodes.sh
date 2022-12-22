#!/bin/bash -e

# config
CURDIR=$(pwd)
SYSDIR=$(cd "$(dirname "$0")"; pwd | xargs dirname)
NETDIR="./privatenet"

FILE_GENESIS="${NETDIR}/genesis.json"
FILE_PEERS="${NETDIR}/static-nodes.json"

# change directory
if ! [ "$CURDIR" == "$SYSDIR" ]; then
  echo ""
  echo "change directory: ${SYSDIR}"
  cd "$SYSDIR"
fi

# init node 1 - 5
if ! [ -f "${FILE_GENESIS}" ]; then
  cp -f "${SYSDIR}/docker/geth/genesis-poa.json" "${FILE_GENESIS}"
fi

DELIM=","
echo "[" > "$FILE_PEERS"

for i in {1..5} ; do
  echo ""
  echo "init node ${i} ..."
  echo ""

  if [ $i -eq 5 ]; then
    DELIM=""
  fi

  mkdir -p "${NETDIR}/nodes/node${i}"
  geth --datadir "${NETDIR}/nodes/node${i}/" init "${NETDIR}/genesis.json"

  ENODE=$(bootnode --nodekey="${NETDIR}/nodes/node${i}/geth/nodekey" --writeaddress)
  ENODE="  \"enode://${ENODE}@node${i}:30303\"${DELIM}"
  echo "$ENODE" >> "$FILE_PEERS"
done

echo "]" >> "$FILE_PEERS"

echo ""
echo "init nodes done."
echo ""

exit 0
