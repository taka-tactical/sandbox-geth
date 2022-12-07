#!/bin/bash -e

if [ $# -lt 1 ]; then
  echo ""
  echo "too few arguments: $#"
  echo ""
  echo "  usage: $0 [options] SRCFILE"
  echo ""
  exit 1
fi

docker-compose run --rm solc $*
