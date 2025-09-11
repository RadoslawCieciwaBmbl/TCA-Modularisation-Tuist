#!/bin/bash
set -euo pipefail

echo "==> Check Xcode version"
/usr/bin/xcodebuild -version

echo "==> Installing dependencies with tuist..."
tuist install

echo "==> Generating Xcode project with tuist..."
tuist generate --no-open

echo "==> Building the project with xcodebuild..."
set -o pipefail && NSUnbufferedIO=YES xcodebuild build \
	-workspace TCA-Modularisation-Tuist.xcworkspace \
	-scheme TCA-Modularisation-Tuist \
	-destination "platform=iOS Simulator,name=iPhone 16,OS=18.5" \
    2>&1 | xcbeautify --renderer github-actions
