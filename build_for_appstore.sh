#!/bin/bash

PROJECT_NAME="MusicPlayer-LM"
SCHEME_NAME="MusicPlayer-LM"
ARCHIVE_PATH="./build/MusicPlayer.xcarchive"
EXPORT_PATH="./build/Export"
PLIST_PATH="./ExportOptions.plist"

echo "Starting App Store Export Process..."

xcodebuild clean -project "$PROJECT_NAME.xcodeproj" -scheme "$SCHEME_NAME" > /dev/null

xcodebuild archive \
  -project "$PROJECT_NAME.xcodeproj" \
  -scheme "$SCHEME_NAME" \
  -configuration Release \
  -archivePath "$ARCHIVE_PATH" \
  -destination 'generic/platform=iOS' \
  -quiet || { echo "Archive failed"; exit 1; }

echo "Archive created at $ARCHIVE_PATH"

xcodebuild -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportOptionsPlist "$PLIST_PATH" \
  -exportPath "$EXPORT_PATH" \
  -allowProvisioningUpdates || { echo "Export failed. Make sure you are signed into Xcode with your Developer Account."; exit 1; }

echo "SUCCESS! Your App Store package is ready."
echo "Location: $EXPORT_PATH/$SCHEME_NAME.ipa"
echo "OPEN TRANSPORTER APP AND DRAG THIS FILE IN TO UPLOAD."
