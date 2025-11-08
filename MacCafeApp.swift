//
//  MacCafeApp.swift
//  MacCafe
//

import SwiftUI

@main
struct MacCafeApp: App {
    @StateObject private var caffeineManager = CaffeineManager()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(caffeineManager)
                .frame(minWidth: 400, idealWidth: 450, maxWidth: 500,
                       minHeight: 500, idealHeight: 550, maxHeight: 600)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("About MacCafe") {
                    NSApp.orderFrontStandardAboutPanel(
                        options: [
                            .applicationName: "MacCafe",
                            .applicationVersion: "1.0.0",
                            .credits: NSAttributedString(string: "© MacCafe\nKeep your Mac awake with style!"),
                        ]
                    )
                }
            }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Set up the app to appear in the dock
        NSApp.setActivationPolicy(.regular)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
