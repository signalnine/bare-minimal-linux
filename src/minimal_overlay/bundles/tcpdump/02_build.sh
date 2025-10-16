#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Build libpcap first
cd $(ls -d libpcap-*)

if [ -f Makefile ] ; then
  echo "Cleaning libpcap work area."
  make -j $NUM_JOBS clean
fi

echo "Configuring libpcap."
CFLAGS="$CFLAGS" ./configure \
  --prefix=$DEST_DIR/usr

echo "Building libpcap."
make -j $NUM_JOBS

echo "Installing libpcap."
make -j $NUM_JOBS install

# Build tcpdump
cd $WORK_DIR/overlay/$BUNDLE_NAME
cd $(ls -d tcpdump-*)

if [ -f Makefile ] ; then
  echo "Cleaning tcpdump work area."
  make -j $NUM_JOBS clean
fi

echo "Configuring tcpdump."
CFLAGS="$CFLAGS -I$DEST_DIR/usr/include" \
LDFLAGS="-L$DEST_DIR/usr/lib" \
./configure \
  --prefix=$DEST_DIR/usr

echo "Building tcpdump."
make -j $NUM_JOBS

echo "Installing tcpdump."
make -j $NUM_JOBS install

echo "Reducing tcpdump size."
set +e
strip -g $DEST_DIR/usr/sbin/tcpdump
strip -g $DEST_DIR/usr/lib/libpcap.so*
set -e

# Install to overlay
cp -r --remove-destination $DEST_DIR/* $OVERLAY_ROOTFS

echo "Bundle tcpdump has been installed."

cd $SRC_DIR
