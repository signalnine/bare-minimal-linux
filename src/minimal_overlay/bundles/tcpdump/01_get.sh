#!/bin/sh

set -e

. ../../common.sh

# First get libpcap (required dependency)
LIBPCAP_URL=`read_property LIBPCAP_SOURCE_URL`
LIBPCAP_FILE=${LIBPCAP_URL##*/}

cd $MAIN_SRC_DIR/source/overlay

if [ ! -f $LIBPCAP_FILE ] ; then
  echo "Downloading libpcap from $LIBPCAP_URL"
  wget -c $LIBPCAP_URL
else
  echo "Using local libpcap source bundle $LIBPCAP_FILE"
fi

# Now get tcpdump
DOWNLOAD_URL=`read_property TCPDUMP_SOURCE_URL`
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

if [ ! -f $ARCHIVE_FILE ] ; then
  echo "Downloading tcpdump from $DOWNLOAD_URL"
  wget -c $DOWNLOAD_URL
else
  echo "Using local tcpdump source bundle $ARCHIVE_FILE"
fi

# Extract libpcap
echo "Removing libpcap work area."
rm -rf $WORK_DIR/overlay/$BUNDLE_NAME/libpcap-*
mkdir -p $WORK_DIR/overlay/$BUNDLE_NAME
tar -xzf $LIBPCAP_FILE -C $WORK_DIR/overlay/$BUNDLE_NAME

# Extract tcpdump
echo "Removing tcpdump work area."
rm -rf $WORK_DIR/overlay/$BUNDLE_NAME/tcpdump-*
tar -xzf $ARCHIVE_FILE -C $WORK_DIR/overlay/$BUNDLE_NAME

cd $SRC_DIR
