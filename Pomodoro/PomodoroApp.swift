//
//  PomodoroApp.swift
//  Pomodoro
//
//  Created by Alfie on 14/08/2022.
//

import SwiftUI
import AVFAudio

@main
struct PomodoroApp: App {
    
    init() {      
        // Check if user has launched before
        if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            // Length of study period 1500
            UserDefaults.standard.set(1500, forKey: "studyTime")
            // Length of short break 300
            UserDefaults.standard.set(300, forKey: "breakTime")
            // Length of long break 1800
            UserDefaults.standard.set(1800, forKey: "longBreakTime")
            // Sessions before long break
            UserDefaults.standard.set(5, forKey: "sessionsUntilLongBreak")
            // Completion sound ID
            UserDefaults.standard.set(1005, forKey: "completionSound")
            // Main ring colour
            UserDefaults.standard.setColor(.green, forKey: "color1")
            // Background colour
            UserDefaults.standard.setColor(.white, forKey: "background")
            // Text colour
            UserDefaults.standard.setColor(.primary, forKey: "textColor")
            // Avoids this executing on every launch
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
