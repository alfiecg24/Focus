//
//  PomodoroApp.swift
//  Pomodoro
//
//  Created by Alfie on 14/08/2022.
//

import SwiftUI
import FirebaseCore
import GoogleMobileAds
import AppTrackingTransparency

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Launch!")
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
            // Main ring colour
            UserDefaults.standard.setColor(.green, forKey: "color1")
            // Background colour
            UserDefaults.standard.setColor(Color("Background"), forKey: "background")
            // Text colour
            UserDefaults.standard.setColor(.white, forKey: "textColor")
            // Avoids this executing on every launch
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
        
        // Initialise Firebase and Google Mobile Ads
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // Ask for notification permissions if not already granted
        let center  = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
            if error == nil {
                print("Notification permissions granted!")
            }
        }
        
        return true
    }
    func applicationWillTerminate(_ application: UIApplication) {
        print("Clearing notifications...")
        // Clear pending notifications if user terminates
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

@main
struct PomodoroApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
