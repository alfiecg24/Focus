//
//  PomodoroApp.swift
//  Pomodoro
//
//  Created by Alfie on 14/08/2022.
//

import SwiftUI
import FirebaseCore
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Launch!")
        var log = [String]()
        log.append("Launch: \(Date.now.formatted(date: .omitted, time: .standard))")
        UserDefaults.standard.set(log, forKey: "log")
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
            let newSubject = Subject(name: "Maths", red: 0, green: 0, blue: 1)
            do {
                try UserDefaults.standard.setObject([newSubject], forKey: "subjects")
                try UserDefaults.standard.setObject([Goal](), forKey: "goals")
            } catch {
                print("Could not save subjects/goals to defaults")
                log.append("Could not save subjects/goals to defaults: \(Date.now.formatted(date: .omitted, time: .standard))")
                UserDefaults.standard.set(log, forKey: "log")
            }
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
        var log = UserDefaults.standard.array(forKey: "log") as! [String]
        log.append("Termination: \(Date.now.formatted(date: .omitted, time: .standard))")
        UserDefaults.standard.set(log, forKey: "log")
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
//            TabView {
//                MainView()
//                    .tabItem({
//                        Label("Timer", systemImage: "deskclock")
//                    })
//                PlannerView()
//                    .tabItem({
//                        Label("Planner", systemImage: "calendar.day.timeline.left")
//                    })
//            }
            MainView()
        }
    }
}
