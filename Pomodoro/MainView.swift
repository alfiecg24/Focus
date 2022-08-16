//
//  ContentView.swift
//  Pomodoro
//
//  Created by Alfie on 14/08/2022.
//

import SwiftUI
import CircularProgress
import UserNotifications

// Timer initialisation
let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

struct MainView: View {
    // State variables
    @State private var isActive = false
    @State private var inSession = false
    @State private var counter: Int = 0
    @State var studyCount = 0
    @State var countDiff = 0
    @State private var mode = Mode.study
    
    @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Fetch necessary values from defaults
    @State private var color1: Color = UserDefaults.standard.color(forKey: "color1")
    @State private var background: Color = UserDefaults.standard.color(forKey: "background")
    @State private var textColor: Color = UserDefaults.standard.color(forKey: "textColor")
    @State var sessionsUntilLongBreak = UserDefaults.standard.integer(forKey: "sessionsUntilLongBreak")
    
    // Computed variables
    // Computed because mode will change during runtime
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
    // Computed because counter will change during runtime
    var progress: CGFloat {
        return (CGFloat(counter) / CGFloat(countTo))
    }
    
    private var notificationPublisher = NotificationPublisher()
    
    var body: some View {
        // Navigation view for toolbar + settings
        NavigationView {
            ZStack {
                Color(uiColor: UIColor(background))
                    .ignoresSafeArea()
                VStack {
                    Text(modeName)
                        .foregroundColor(textColor)
                        .font(.custom("Avenir Next", size: 30))
                        .fontWeight(.semibold)
                    // Circle view + clock in the middle
                    ZStack {
                        CircularProgressView(count: counter, total: countTo, progress: progress, fill: (counter == countTo ? LinearGradient(gradient: Gradient(colors: [Color.green]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [color1]), startPoint: .top, endPoint: .bottom)), showText: false, showBottomText: false)
                            .padding(50)
                        Clock(counter: counter, countTo: countTo, textColor: textColor)
                    }
                    // Play/pause button
                    Button(action: {
                        // Checks if ready to start next timer period
                        if counter == countTo {
                            if counter != countTo {
                                if !inSession {
                                    inSession.toggle()
                                }
                                time.upstream.connect().cancel()
                            }
                        }
                        isActive.toggle()
                        setupLocalNotificationsFor()
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
                    VStack {
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
                        Button(action: {
                            // Timer paused, in session and timer is not completed
                            if !isActive && inSession && counter != countTo {
                                isActive = false
                                inSession = false
                                mode = .study
                                counter = 0
                                studyCount = 0
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.success)
                                removeSavedDate()
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
                .onReceive(timer) { time in
                    // Timer active and not yet complete
                    if counter < countTo && isActive {
                        counter += 1
                    }
                    // Timer completed
                    else if counter == countTo {
                        // Study count increases by 1
                        if mode == .study {
                            studyCount += 1
                        }
                        // Timer paused and counter reset
                        isActive = false
                        counter = 0
                        // No long break
                        if studyCount != sessionsUntilLongBreak {
                            if mode == .study {
                                mode = .studyBreak
                            } else if mode == .studyBreak {
                                mode = .study
                            } else if mode == .longStudyBreak {
                                mode = .study
                            }
                        }
                        // Already in long study break
                        else if mode == .longStudyBreak {
                            counter = 0
                            studyCount = 0
                            mode = .study
                        }
                        //
                        else {
                            counter = 0
                            mode = .longStudyBreak
                        }
                    }
                }
                // App goes to background
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    let defaults = UserDefaults.standard
                    defaults.set(Date(), forKey: "saveTime")
                    print(Date())
                }
                // App returns to foreground
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    print("App returning to the foreground")
                    if let saveDate = UserDefaults.standard.object(forKey: "saveTime") as? Date {
                        countDiff = getTimeDifference(startDate: saveDate)
                        refresh(seconds: counter)
                        if countDiff >= countTo || counter >= countTo || !isActive {
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
                            
                            //Stop Local Notifications
                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
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
    }
    func refresh(seconds: Int) {
        counter += seconds
        time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    func setupLocalNotificationsFor() {
        
        let countInterval = 60
        
        notificationPublisher.sendNotification(title:"Time's Up!", subtitle: "", body: "Your \(modeName) segment is complete", delayInterval: countInterval)
    }
    
    func switchModes(mode: Mode, studyCount: Int) -> Mode {
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

}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
