#!/bin/bash
set -euo pipefail

# Set Xcode version if needed (uncomment if running locally and want to match CI)
# export DEVELOPER_DIR="/Applications/Xcode_16.4.app/Contents/Developer"

echo "==> Installing dependencies with tuist..."
tuist install

echo "==> Generating Xcode project with tuist..."
tuist generate --no-open

echo "==> Testing the project with xcodebuild..."
set -o pipefail && NSUnbufferedIO=YES xcodebuild test \
	-workspace TCA-Modularisation-Tuist.xcworkspace \
	-scheme TCA-Modularisation-Tuist \
	-destination "platform=iOS Simulator,name=iPhone 16,OS=18.5" \
    2>&1 | xcbeautify --renderer github-actions
