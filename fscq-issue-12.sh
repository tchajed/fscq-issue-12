#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
FSCQ=$HOME/fscq

start_fscq() {
  "$FSCQ"/src/fscq "$FSCQ"/src/disk.img -f -o big_writes,atomic_o_trunc,use_ino "$1" &
  sleep 0.5
}

unmount_fscq() {
  fusermount -u "$1"
}

check_fscq() {
  start_fscq "$1"
  tree -s "$1"
  unmount_fscq "$1"
}

mkdir -p /tmp/fscqmnt /tmp/fscqmnt2
gcc "$DIR"/fscq-test.c -o "$DIR"/fscq-test
if [ ! -f /tmp/empty.img ]; then
  "$FSCQ"/src/mkfs /tmp/empty.img
fi
cp /tmp/empty.img "$FSCQ"/src/disk.img

start_fscq /tmp/fscqmnt
"$DIR"/fscq-test

check_fscq /tmp/fscqmnt2

unmount_fscq /tmp/fscqmnt # cleanup for another run (required to clean up FUSE state)
