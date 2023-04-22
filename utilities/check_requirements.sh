#!/bin/bash -e

if ! (type docker > /dev/null 2>&1); then
  echo "docker binary not found"
  echo ""
  exit 1
fi

if ! (type geth > /dev/null 2>&1); then
  echo "geth binary not found"
  echo ""
  exit 1
fi

if ! (type bootnode > /dev/null 2>&1); then
  echo "bootnode binary not found"
  echo ""
  exit 1
fi

exit 0
