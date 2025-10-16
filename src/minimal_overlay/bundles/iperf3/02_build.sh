#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME
cd $(ls -d iperf-*)

if [ -f Makefile ] ; then
  echo "Cleaning iperf3 work area."
  make -j $NUM_JOBS clean
fi

rm -rf $DEST_DIR

echo "Configuring iperf3."
CFLAGS="$CFLAGS" ./configure \
  --prefix=$DEST_DIR/usr

echo "Building iperf3."
make -j $NUM_JOBS

echo "Installing iperf3."
make -j $NUM_JOBS install

echo "Reducing iperf3 size."
set +e
strip -g $DEST_DIR/usr/bin/iperf3
strip -g $DEST_DIR/usr/lib/libiperf.so*
set -e

cp -r --remove-destination $DEST_DIR/* $OVERLAY_ROOTFS

echo "Bundle iperf3 has been installed."

cd $SRC_DIR
