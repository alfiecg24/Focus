//
//  ContentView.swift
//  Pomodoro
//
//  Created by Alfie on 14/08/2022.
//

import SwiftUI
import CircularProgress
import UserNotifications


// Study modes
enum Mode {
    case study
    case studyBreak
    case longStudyBreak
}

struct MainView: View {
    // State variables - private because they won't be accessed outside this scope
    @State private var isActive = false
    @State private var inSession = false
    @State private var counter: Int = 0
    @State private var studyCount = 0
    @State private var countDiff = 0
    @State private var mode = Mode.study
    @State private var inBackground = false
    @State private var segmentSkips = 0
    
    // Timer
    @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Fetch necessary values from defaults
    @State private var color1: Color = UserDefaults.standard.color(forKey: "color1")
    @State private var background: Color = UserDefaults.standard.color(forKey: "background")
    @State private var textColor: Color = UserDefaults.standard.color(forKey: "textColor")
    @State private var sessionsUntilLongBreak = UserDefaults.standard.integer(forKey: "sessionsUntilLongBreak")
    
    // Computed variables - dependent on the State variables
    var countTo: Int {
        let defaults = UserDefaults.standard
        switch mode {
        case .study:
            return defaults.integer(forKey: "studyTime")
        case .studyBreak:
            return defaults.integer(forKey: "breakTime")
        case .longStudyBreak:
            return defaults.integer(forKey: "longBreakTime")
        }
    }
    var modeName: String {
        switch mode {
        case .study:
            return "Study"
        case .studyBreak:
            return "Break"
        case .longStudyBreak:
            return "Long break"
        }
    }
    var progress: CGFloat {
        return (CGFloat(counter) / CGFloat(countTo))
    }
    
    // Models
    private var notificationPublisher = NotificationPublisher()
    private var adsViewModel = AdsViewModel()
    
    var body: some View {
        // Navigation view for toolbar + settings
        NavigationView {
            ZStack {
                // User-chosen background colour
                Color(uiColor: UIColor(background))
                    .ignoresSafeArea()
                VStack {
                    Text(modeName)
                        .foregroundColor(textColor)
                        .font(.custom("Avenir Next", size: 30))
                        .fontWeight(.semibold)
                    // Circle view + clock in the middle
                    ZStack {
                        CircularProgressView(count: counter, total: countTo, progress: progress, fill: (counter == countTo ? LinearGradient(gradient: Gradient(colors: [Color.green]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [color1]), startPoint: .top, endPoint: .bottom)), lineWidth: 15, showText: false, showBottomText: false)
                            .padding(.horizontal, UIScreen.main.bounds.width/8)
                            .padding(.vertical, 15)
                        Clock(counter: counter, countTo: countTo, textColor: textColor)
                    }
                    // Play/pause button
                    Button(action: {
                        withAnimation {
                            // Checks if ready to start next timer period
                            if counter == countTo {
                                time.upstream.connect().cancel()
                            }
                            if counter != countTo {
                                if !inSession {
                                    inSession.toggle()
                                }
                                
                            }
                            isActive.toggle()
                            // Resets existing notifications and reschedules
                            if !isActive {
                                clearNotifications()
                            } else {
                                clearNotifications()
                                setupLocalNotificationsFor()
                            }
                        }
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred(intensity: 1.0)
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                .opacity(0.3)
                                .foregroundColor(Color.secondary)
                                .frame(width: 300, height: 75)
                            if #available(iOS 16.0, *) {
                                Label(isActive ? "Pause": "Start", systemImage: isActive ? "pause" : "play")
                                    .foregroundColor(textColor)
                                    .font(.custom("Avenir Next", size: 30))
                                    .fontWeight(.semibold)
                            } else {
                                Label(isActive ? "Pause": "Start", systemImage: isActive ? "pause" : "play")
                                    .foregroundColor(textColor)
                                    .font(.custom("Avenir Next", size: 30))
                            }
                        }
                    })
                    if (!isActive && inSession && counter != countTo) {
                        VStack {
                            // Skip segment button
                            Button(action: {
                                counter = 0
                                if mode == .study {
                                    studyCount += 1
                                    mode = switchModes(mode: mode, studyCount: studyCount)
                                }
                                else if mode == .longStudyBreak {
                                    mode = switchModes(mode: mode, studyCount: studyCount)
                                    studyCount = 0
                                } else {
                                    mode = switchModes(mode: mode, studyCount: studyCount)
                                }
                                segmentSkips += 1
                                clearNotifications()
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.warning)
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                        .opacity(!isActive && inSession && counter != countTo ? 0.3 : 1.0)
                                        .foregroundColor(!isActive && inSession && counter != countTo ? .secondary : background)
                                        .frame(width: 130, height: 40)
                                    Text("Skip segment")
                                        .font(.custom("Avenir Next", size: 17))
                                        .fontWeight(.light)
                                        .foregroundColor(!isActive && inSession && counter != countTo ? .green : background)
                                }
                            })
                            .padding(.bottom)
                            
                            // End session button
                            Button(action: {
                                // Timer paused, in session and timer is not completed
                                if !isActive && inSession && counter != countTo {
                                    isActive = false
                                    inSession = false
                                    mode = .study
                                    counter = 0
                                    studyCount = 0
                                    clearNotifications()
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                    removeSavedDate()
                                    //adsViewModel.showInterstitial.toggle()
                                }
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                        .opacity(!isActive && inSession && counter != countTo ? 0.3 : 1.0)
                                        .foregroundColor(!isActive && inSession && counter != countTo ? .secondary : background)
                                        .frame(width: 130, height: 40)
                                    Text("End session")
                                        .font(.custom("Avenir Next", size: 17))
                                        .fontWeight(.light)
                                        .foregroundColor(!isActive && inSession && counter != countTo ? .red : background)
                                }
                            })
                        }
                        .padding()
    //                    .hiddenConditionally(isHidden: !(!isActive && inSession && counter != countTo))
    //
                    }
                }
                .onAppear {
                    // Refresh times if changed in settings
                    if mode == .study {
                        mode = .studyBreak
                        mode = .study
                    } else {
                        mode = .study
                        mode = .studyBreak
                    }
                    // Refresh colors if changed in settings
                    color1 = UserDefaults.standard.color(forKey: "color1")
                    background = UserDefaults.standard.color(forKey: "background")
                    textColor = UserDefaults.standard.color(forKey: "textColor")
                    sessionsUntilLongBreak = UserDefaults.standard.integer(forKey: "sessionsUntilLongBreak")
                }
                // Timer mechanism
                .onReceive(time) { time in
                    // Checks if user has skipped 5 segments, shows advert if true
                    if segmentSkips >= 5 && !isActive {
                        //adsViewModel.showInterstitial.toggle()
                        segmentSkips = 0
                    }
                    if isActive {
                        // Timer active and not yet complete
                        if counter < countTo {
                            counter += 1
                        }
                        // Timer completed
                        else if counter == countTo {
                            counter = 0
                            isActive.toggle()
                            clearNotifications()
                            if mode == .study {
                                // Shows advert at the end of a study session
                                let state = UIApplication.shared.applicationState
                                if state == .active {
                                    //adsViewModel.showInterstitial.toggle()
                                }
                                studyCount += 1
                                mode = switchModes(mode: mode, studyCount: studyCount)
                            }
                            else if mode == .longStudyBreak {
                                // Shows advert at the end of a long study break
                                let state = UIApplication.shared.applicationState
                                if state == .active {
                                    //adsViewModel.showInterstitial.toggle()
                                }
                                mode = switchModes(mode: mode, studyCount: studyCount)
                                studyCount = 0
                            } else {
                                mode = switchModes(mode: mode, studyCount: studyCount)
                            }
                            
                        }
                    }
                }
                // App goes to background
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    inBackground = true
                    print("App going to the background")
                    // Clear existing notifications
                    clearNotifications()
                    if isActive {
                        setupLocalNotificationsFor()
                    }
                    let defaults = UserDefaults.standard
                    defaults.set(Date.now, forKey: "saveTime")
                    defaults.set(counter, forKey: "saveCount")
                    print(Date())
                }
                // App returns to foreground
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    inBackground = false
                    print("App returning to the foreground")
                    print("Saved date: \(UserDefaults.standard.object(forKey: "saveTime") as! Date)")
                    print("Current date: \(Date.now)")
                    if let saveDate = UserDefaults.standard.object(forKey: "saveTime") as? Date {
                        // Calculate time in background
                        countDiff = getTimeDifference(startDate: saveDate)
                        let saveCount = UserDefaults.standard.integer(forKey: "saveCount")
                        print("You were gone for \(countDiff) seconds, adding to counter")
                        if isActive {
                            counter = saveCount + countDiff
                            
                        }
                        // Timer is finished
                        if countDiff >= countTo || counter >= countTo {
                            removeSavedDate()
                            counter = 0
                            countDiff = 0
                            isActive = false
                            
                            if mode == .study {
                                studyCount += 1
                                mode = switchModes(mode: mode, studyCount: studyCount)
                            }
                            else if mode == .longStudyBreak {
                                mode = switchModes(mode: mode, studyCount: studyCount)
                                studyCount = 0
                            } else {
                                mode = switchModes(mode: mode, studyCount: studyCount)
                            }
                            
                            clearNotifications()
                            setupLocalNotificationsFor()
                        } else {
                            removeSavedDate()
                            time.upstream.connect().cancel()
                        }
                    }
                }
            }
            // Settings button
            .toolbar {
                NavigationLink(destination: {
                    SettingsView(inSession: inSession)
                }, label: {
                    Image(systemName: "gear")
                        .foregroundColor(textColor)
                })
            }
        }
        .navigationViewStyle(.stack)

    }
    func refresh(seconds: Int) {
        counter += seconds
        time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    func setupLocalNotificationsFor() {
        
        print("Setting up local notifications")
        
        // Get time difference
        let countInterval = countTo - counter
        // Schedule the notification
        notificationPublisher.sendNotification(title:"Time's Up!", subtitle: "", body: "Your \(modeName) segment is complete", delayInterval: countInterval)
    }
    
    func switchModes(mode: Mode, studyCount: Int) -> Mode {
        // Change mode and calculate whether there's a long break
        switch mode {
        case .study:
            if studyCount == sessionsUntilLongBreak
            {
                return .longStudyBreak
            }
            else
            {
                return .studyBreak
            }
        case .studyBreak:
            return .study
        case .longStudyBreak:
            return .study
        }
    }
    
    func clearNotifications() {
        print("Clearing notifications")
        // Clear all scheduled notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

extension View {
    func hiddenConditionally(isHidden: Bool) -> some View {
        isHidden ? AnyView(self.hidden()) : AnyView(self)
    }
}
