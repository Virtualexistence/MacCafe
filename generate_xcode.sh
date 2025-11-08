#!/bin/bash

echo "🐱☕ Generating Xcode project for MacCafe..."
swift package generate-xcodeproj

if [ $? -eq 0 ]; then
    echo "✅ Xcode project generated successfully!"
    echo "Opening in Xcode..."
    open MacCafe.xcodeproj
else
    echo "❌ Failed to generate Xcode project"
    exit 1
fi
