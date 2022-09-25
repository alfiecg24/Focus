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
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["SegmentCompletionNotification"])
        var log = [String]()
        log.append("Launch: \(Date.now.formatted(date: .omitted, time: .standard))")
        UserDefaults.standard.set(log, forKey: "log")
        let intOptions = ["studyTime", "breakTime", "longBreakTime", "sessionsUntilLongBreak"]
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
            UserDefaults.standard.set("Study", forKey: "workSegmentName")
        }
        
        for opt in intOptions {
            if !UserDefaults.exists(key: opt) {
                switch opt {
                case "studyTime": UserDefaults.standard.set(1500, forKey: opt)
                case "breakTime": UserDefaults.standard.set(300, forKey: opt)
                case "longBreakTime": UserDefaults.standard.set(1800, forKey: opt)
                case "sessionsUntilLongBreak": UserDefaults.standard.set(5, forKey: opt)
                default: break
                }
            }
        }
        
        if !UserDefaults.exists(key: "color1") {
            UserDefaults.standard.setColor(.green, forKey: "color1")
        }
        
        if !UserDefaults.exists(key: "background") {
            UserDefaults.standard.setColor(Color("Background"), forKey: "background")
        }
        
        if !UserDefaults.exists(key: "textColor") {
            UserDefaults.standard.setColor(.white, forKey: "textColor")
        }
        
        if !UserDefaults.exists(key: "workSegmentName") {
            UserDefaults.standard.set("Study", forKey: "workSegmentName")
        }
        
        if !UserDefaults.exists(key: "subjects") {
            let newSubject = Subject(name: "Maths", red: 0, green: 0, blue: 1)
            do {
                try UserDefaults.standard.setObject([newSubject], forKey: "subjects")
                try UserDefaults.standard.setObject([Goal](), forKey: "goals")
            } catch {
                print("Could not save subjects/goals to defaults")
                log.append("Could not save subjects/goals to defaults: \(Date.now.formatted(date: .omitted, time: .standard))")
                UserDefaults.standard.set(log, forKey: "log")
            }
        }
        
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            switch status {
            case .notDetermined:
                print("Tracking authorisation not determined")
            case .restricted:
                print("Tracking restricted")
            case .denied:
                print("Tracking denied")
            case .authorized:
                print("Tracking authorised!")
            @unknown default:
                print("Unknown tracking authorisation status!")
            }
        })
        
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
        let previousLaunch = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
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
            if previousLaunch {
                TabView {
                    MainView()
                        .tabItem({
                            Label("Timer", systemImage: "deskclock")
                        })
                    PlannerView()
                        .tabItem({
                            Label("Planner", systemImage: "calendar.day.timeline.left")
                        })
                }
                .onAppear {
                    ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                        switch status {
                        case .notDetermined:
                            print("Tracking authorisation not determined")
                        case .restricted:
                            print("Tracking restricted")
                        case .denied:
                            print("Tracking denied")
                        case .authorized:
                            print("Tracking authorised!")
                        @unknown default:
                            print("Unknown tracking authorisation status!")
                        }
                    })
                }
            } else {
                SplashScreenView()
                    .onAppear {
                        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                            switch status {
                            case .notDetermined:
                                print("Tracking authorisation not determined")
                            case .restricted:
                                print("Tracking restricted")
                            case .denied:
                                print("Tracking denied")
                            case .authorized:
                                print("Tracking authorised!")
                            @unknown default:
                                print("Unknown tracking authorisation status!")
                            }
                        })
                    }
            }
        }
    }
}

extension UserDefaults {

    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

}
