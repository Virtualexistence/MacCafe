//
//  ContentView.swift
//  MacCafe
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var caffeineManager: CaffeineManager
    @State private var selectedDuration: TimeInterval = 3600 // Default 1 hour
    @State private var customHours: Double = 1
    @State private var customMinutes: Double = 0
    @State private var showCustomTime = false
    
    private let presetDurations: [(String, TimeInterval)] = [
        ("30 Minutes", 1800),
        ("1 Hour", 3600),
        ("2 Hours", 7200),
        ("4 Hours", 14400),
        ("8 Hours", 28800),
        ("Until Stopped", 0), // 0 means indefinite
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Top section with animation
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.95, green: 0.9, blue: 0.85),
                             Color(red: 0.98, green: 0.95, blue: 0.92)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                VStack {
                    // Cat Animation View
                    CatAnimationView(isActive: caffeineManager.isActive)
                        .frame(height: 200)
                        .padding(.top, 20)
                    
                    // Status Text
                    Text(caffeineManager.isActive ? "Keeping your Mac awake ☕️" : "Your Mac can sleep 😴")
                        .font(.headline)
                        .foregroundColor(caffeineManager.isActive ? .green : .secondary)
                        .padding(.bottom, 10)
                    
                    if caffeineManager.isActive && caffeineManager.duration > 0 {
                        Text("Time remaining: \(timeString(from: caffeineManager.remainingTime))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 10)
                    }
                }
            }
            .frame(height: 280)
            
            // Control section
            VStack(spacing: 20) {
                // Duration Selection
                if !caffeineManager.isActive {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select Duration")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView {
                            VStack(spacing: 8) {
                                ForEach(presetDurations, id: \.1) { duration in
                                    DurationButton(
                                        title: duration.0,
                                        isSelected: selectedDuration == duration.1,
                                        action: {
                                            selectedDuration = duration.1
                                            showCustomTime = false
                                        }
                                    )
                                }
                                
                                DurationButton(
                                    title: "Custom Time",
                                    isSelected: showCustomTime,
                                    action: {
                                        showCustomTime = true
                                        selectedDuration = (customHours * 3600) + (customMinutes * 60)
                                    }
                                )
                            }
                            .padding(.horizontal)
                        }
                        .frame(maxHeight: 150)
                        
                        if showCustomTime {
                            CustomTimeSelector(hours: $customHours, minutes: $customMinutes) {
                                selectedDuration = (customHours * 3600) + (customMinutes * 60)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                // Action Buttons
                HStack(spacing: 20) {
                    if caffeineManager.isActive {
                        Button(action: {
                            caffeineManager.stop()
                        }) {
                            Label("Stop", systemImage: "stop.fill")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                        }
                        .controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    } else {
                        Button(action: {
                            caffeineManager.start(duration: selectedDuration)
                        }) {
                            Label("Start Caffeinating", systemImage: "cup.and.saucer.fill")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                        }
                        .controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .tint(.brown)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            }
            .padding(.top, 20)
            .background(Color(NSColor.controlBackgroundColor))
        }
        .background(Color(NSColor.windowBackgroundColor))
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

struct DurationButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(isSelected ? .white : .primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.brown : Color(NSColor.controlBackgroundColor))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct CustomTimeSelector: View {
    @Binding var hours: Double
    @Binding var minutes: Double
    let onUpdate: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Hours:")
                    .frame(width: 60, alignment: .leading)
                Slider(value: $hours, in: 0...24, step: 1) { _ in
                    onUpdate()
                }
                Text("\(Int(hours))")
                    .frame(width: 30)
            }
            
            HStack {
                Text("Minutes:")
                    .frame(width: 60, alignment: .leading)
                Slider(value: $minutes, in: 0...59, step: 5) { _ in
                    onUpdate()
                }
                Text("\(Int(minutes))")
                    .frame(width: 30)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(NSColor.controlBackgroundColor))
        )
    }
}

#Preview {
    ContentView()
        .environmentObject(CaffeineManager())
}
