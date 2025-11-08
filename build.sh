#!/bin/bash

# MacCafe Build Script
# This script builds and optionally runs the MacCafe application

echo "🐱☕ MacCafe Build Script"
echo "========================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if we're in the right directory
if [ ! -f "Package.swift" ]; then
    echo -e "${RED}Error: Package.swift not found. Please run this script from the MacCafe directory.${NC}"
    exit 1
fi

# Function to build with Swift Package Manager
build_spm() {
    echo -e "${YELLOW}Building with Swift Package Manager...${NC}"
    
    # Clean previous build
    echo "Cleaning previous build..."
    swift package clean
    
    # Build in release mode
    echo "Building MacCafe..."
    if swift build -c release; then
        echo -e "${GREEN}✅ Build successful!${NC}"
        return 0
    else
        echo -e "${RED}❌ Build failed!${NC}"
        return 1
    fi
}

# Function to generate and open Xcode project
build_xcode() {
    echo -e "${YELLOW}Generating Xcode project...${NC}"
    
    # Generate Xcode project
    if swift package generate-xcodeproj; then
        echo -e "${GREEN}✅ Xcode project generated!${NC}"
        
        # Ask if user wants to open in Xcode
        read -p "Do you want to open the project in Xcode? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            open MacCafe.xcodeproj
            echo -e "${GREEN}Project opened in Xcode. Build and run using ⌘R${NC}"
        fi
    else
        echo -e "${RED}❌ Failed to generate Xcode project!${NC}"
        return 1
    fi
}

# Main menu
echo "Choose build method:"
echo "1) Build with Swift Package Manager"
echo "2) Generate and open Xcode project"
echo "3) Exit"

read -p "Enter your choice (1-3): " choice

case $choice in
    1)
        if build_spm; then
            # Ask if user wants to run the app
            read -p "Do you want to run MacCafe now? (y/n): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo -e "${GREEN}Launching MacCafe...${NC}"
                ./.build/release/MacCafe &
                echo -e "${GREEN}MacCafe is running!${NC}"
            else
                echo -e "${YELLOW}You can run MacCafe later with: ./.build/release/MacCafe${NC}"
            fi
        fi
        ;;
    2)
        build_xcode
        ;;
    3)
        echo "Goodbye! ☕️"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice. Please run the script again.${NC}"
        exit 1
        ;;
esac

echo ""
echo "Thank you for using MacCafe! 🐱☕"
