#!/bin/sh

set -e

. ../../common.sh

DOWNLOAD_URL=`read_property IPERF3_SOURCE_URL`
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

cd $MAIN_SRC_DIR/source/overlay

if [ ! -f $ARCHIVE_FILE ] ; then
  echo "Downloading iperf3 from $DOWNLOAD_URL"
  wget -c $DOWNLOAD_URL
else
  echo "Using local iperf3 source bundle $ARCHIVE_FILE"
fi

echo "Removing iperf3 work area."
rm -rf $WORK_DIR/overlay/$BUNDLE_NAME
mkdir -p $WORK_DIR/overlay/$BUNDLE_NAME

tar -xzf $ARCHIVE_FILE -C $WORK_DIR/overlay/$BUNDLE_NAME

cd $SRC_DIR
