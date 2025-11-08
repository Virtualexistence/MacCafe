//
//  CaffeineManager.swift
//  MacCafe
//
//  Created on November 8, 2025
//

import Foundation
import Combine

class CaffeineManager: ObservableObject {
    @Published var isActive = false
    @Published var remainingTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    
    private var process: Process?
    private var timer: Timer?
    private var startTime: Date?
    
    func start(duration: TimeInterval) {
        stop() // Stop any existing process
        
        // Create the caffeinate process
        process = Process()
        process?.executableURL = URL(fileURLWithPath: "/usr/bin/caffeinate")
        
        // -d prevents display sleep
        // -u prevents system sleep
        // -i prevents system idle sleep
        var arguments = ["-d", "-u", "-i"]
        
        // If duration is specified (not 0), add timeout
        if duration > 0 {
            arguments.append("-t")
            arguments.append(String(Int(duration)))
            self.duration = duration
            self.remainingTime = duration
            startTimer()
        } else {
            self.duration = 0
            self.remainingTime = 0
        }
        
        process?.arguments = arguments
        
        // Set up termination handler
        process?.terminationHandler = { [weak self] _ in
            DispatchQueue.main.async {
                self?.handleProcessTermination()
            }
        }
        
        // Start the process
        do {
            try process?.run()
            isActive = true
            startTime = Date()
        } catch {
            print("Failed to start caffeinate: \(error)")
            isActive = false
        }
    }
    
    func stop() {
        // Terminate the caffeinate process
        if let process = process, process.isRunning {
            process.terminate()
        }
        
        // Clean up
        process = nil
        timer?.invalidate()
        timer = nil
        isActive = false
        remainingTime = 0
        duration = 0
        startTime = nil
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateRemainingTime()
        }
    }
    
    private func updateRemainingTime() {
        guard let startTime = startTime, duration > 0 else { return }
        
        let elapsed = Date().timeIntervalSince(startTime)
        let remaining = max(0, duration - elapsed)
        
        DispatchQueue.main.async {
            self.remainingTime = remaining
            
            if remaining <= 0 {
                self.stop()
            }
        }
    }
    
    private func handleProcessTermination() {
        isActive = false
        timer?.invalidate()
        timer = nil
        remainingTime = 0
        duration = 0
        startTime = nil
    }
    
    deinit {
        stop()
    }
}
