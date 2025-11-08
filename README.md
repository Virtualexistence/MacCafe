# MacCafe ☕️🐱

A delightful macOS application that keeps your Mac awake with adorable cat animations! MacCafe is a user-friendly wrapper around the `caffeinate` command, featuring a playful cat that interacts with a coffee mug.

## Features

- **Intuitive Timer Control**: Choose from preset durations (30 minutes to 8 hours) or set a custom time
- **Adorable Animations**: 
  - **Idle State**: Watch the cat playfully run and jump around the coffee mug
  - **Active State**: The cat sips coffee when your Mac is being kept awake
- **Visual Feedback**: Clear indication of whether caffeinate is active
- **Process Management**: Properly manages the underlying caffeinate process
- **Beautiful UI**: Modern SwiftUI interface with smooth animations

## Animation States

### Idle Animation (Caffeinate Off)
- Cat runs back and forth near the coffee mug
- Playful jumping animations
- Tail wagging and eye blinking
- Curious exploration movements

### Active Animation (Caffeinate On)
- Cat holds and sips from the coffee mug
- Steam rises from the hot coffee
- Contented tail wagging
- Paw movements while holding the mug

## Building the App

### Method 1: Using Xcode (Recommended)

1. Open Terminal and navigate to the project directory:
   ```bash
   cd /path/to/MacCafe
   ```

2. Generate an Xcode project:
   ```bash
   swift package generate-xcodeproj
   ```

3. Open the generated project in Xcode:
   ```bash
   open MacCafe.xcodeproj
   ```

4. In Xcode:
   - Select the MacCafe target
   - Choose your Mac as the destination
   - Press ⌘R to build and run

### Method 2: Using Swift Build

1. Open Terminal and navigate to the project directory:
   ```bash
   cd /path/to/MacCafe
   ```

2. Build the application:
   ```bash
   swift build -c release
   ```

3. Run the application:
   ```bash
   ./.build/release/MacCafe
   ```

### Method 3: Using the Build Script

1. Make the build script executable:
   ```bash
   chmod +x build.sh
   ```

2. Run the build script:
   ```bash
   ./build.sh
   ```

## Usage

1. **Launch the App**: Double-click the MacCafe app icon or run from Terminal

2. **Select Duration**: 
   - Choose from preset options (30 min, 1 hr, 2 hrs, 4 hrs, 8 hrs, or indefinite)
   - Or select "Custom Time" to set specific hours and minutes

3. **Start Caffeinating**: 
   - Click "Start Caffeinating" to keep your Mac awake
   - Watch the cat start sipping coffee!

4. **Monitor Status**: 
   - The app shows remaining time for timed sessions
   - Green status indicates caffeinate is active

5. **Stop Anytime**: 
   - Click "Stop" to allow your Mac to sleep normally again
   - The cat returns to playing around

## How It Works

MacCafe uses the built-in macOS `caffeinate` command with the following flags:
- `-d`: Prevents display sleep
- `-u`: Prevents system sleep  
- `-i`: Prevents system idle sleep
- `-t [seconds]`: Sets a timeout duration (optional)

The app provides a beautiful, intuitive interface to this powerful utility while entertaining you with charming cat animations!

## System Requirements

- macOS 13.0 (Ventura) or later
- Swift 5.9 or later
- Xcode 15.0 or later (for building)

## Technical Details

- Built with SwiftUI for modern, native macOS experience
- Programmatic sprite animations using SwiftUI shapes and animations
- Proper process lifecycle management
- Timer-based state updates
- Responsive layout that adapts to window resizing

## Features in Detail

### Timer Options
- Quick presets for common durations
- Custom time selector with hour and minute sliders
- "Until Stopped" option for indefinite sessions
- Real-time countdown display

### Animation System
- Smooth 60fps animations
- Multiple animation layers (cat, mug, steam, background)
- Synchronized animation states
- Eye blinking and tail wagging for lifelike movement
- Physics-based jumping animations

### User Interface
- Clean, minimalist design
- Color-coded status indicators
- Responsive button states
- Smooth transitions between states
- Hidden title bar for cleaner appearance

## Troubleshooting

### App Won't Build
- Ensure you have Xcode 15+ installed
- Check that you're running macOS 13.0+
- Try cleaning the build folder: `swift package clean`

### Caffeinate Not Working
- The app requires no special permissions
- If issues persist, try running `caffeinate -d` directly in Terminal to test

### Animations Not Smooth
- Ensure no other heavy processes are running
- Check that your Mac isn't in Low Power Mode
- Try restarting the application

## Contributing

Feel free to fork this project and add your own features! Some ideas:
- Additional animal characters
- Different coffee mug designs
- Sound effects
- Menu bar integration
- Keyboard shortcuts
- Statistics tracking

## License

This project is created for personal use. Feel free to modify and distribute as needed.

## Credits

Created with ❤️ and ☕️ for Mac users who need their computers to stay awake!

---

*Remember: While MacCafe keeps your Mac awake, don't forget to take breaks and rest yourself!*
