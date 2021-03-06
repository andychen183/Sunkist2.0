#!/usr/bin/env bash

VERSIONNAME=`git describe --always --tags | sed -e 's/^v//'`

# Android versionCode from git tag vX.Y.Z-123-gSHA
IFS=. read major minor patch dev sha <<<"${VERSIONNAME//-/.}"
VERSIONCODE=$(($major*100000))
VERSIONCODE=$(($(($minor*10000)) + $VERSIONCODE))
VERSIONCODE=$(($(($patch*1000)) + $VERSIONCODE))
VERSIONCODE=$(($(($dev)) + $VERSIONCODE))

MANIFEST_FILE=android/AndroidManifest.xml
if [ -n "$VERSIONCODE" ]; then
	sed -i -e "s/android:versionCode=\"[0-9][0-9]*\"/android:versionCode=\"$VERSIONCODE\"/" $MANIFEST_FILE
	echo "Android version: ${VERSIONCODE}"
else
	echo "Error versionCode empty"
	exit 0 # don't cause the build to fail
fi

if [ -n "$VERSIONNAME" ]; then
	sed -i -e 's/versionName *= *"[^"]*"/versionName="'$VERSIONNAME'"/' $MANIFEST_FILE
	echo "Android name: ${VERSIONNAME}"
else
	echo "Error versionName empty"
	exit 0 # don't cause the build to fail
fi

