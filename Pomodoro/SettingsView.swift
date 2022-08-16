//
//  SettingsView.swift
//  Pomodoro
//
//  Created by Alfie on 14/08/2022.
//

import SwiftUI
import AVFoundation

struct SettingsView: View {
    @State private var studyTime = UserDefaults.standard.integer(forKey: "studyTime") / 60
    @State private var breakTime = UserDefaults.standard.integer(forKey: "breakTime") / 60
    @State private var longBreakTime = UserDefaults.standard.integer(forKey: "longBreakTime") / 60
    @State private var sessionsUntilLongBreak = UserDefaults.standard.integer(forKey: "sessionsUntilLongBreak")
    @State private var color1: Color = UserDefaults.standard.color(forKey: "color1")
    @State private var background: Color = UserDefaults.standard.color(forKey: "background")
    @State private var textColor: Color = UserDefaults.standard.color(forKey: "textColor")
    
    @State private var soundID: UInt32 = UInt32(UserDefaults.standard.integer(forKey: "completionSound"))
    
    @State private var id = 0
    @State private var soundName = "Alarm"

    let inSession: Bool
    let studyTimeOptions = [1, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]
    let breakTimeOptions = [1, 5, 10, 15, 20, 25, 30]
    let longBreakTimeOptions = [15, 20, 25, 30, 35, 40, 45]
    let soundOptions = [0, 1005, 1016, 1320, 1321, 1322, 1327, 1332]
    let soundNames = ["None", "Alarm", "Tweet", "Anticipate", "Bloom", "Calypso", "Minuet", "Suspense"]
    var body: some View {
        Form {
            Section(content: {
                Picker("Study time", selection: $studyTime) {
                    ForEach(studyTimeOptions, id: \.self) {
                        Text("\($0) minutes")
                    }
                }
                .disabled(inSession)
                .onChange(of: studyTime) { _ in
                    UserDefaults.standard.set(studyTime * 60, forKey: "studyTime")

                }
                Picker("Break time", selection: $breakTime) {
                    ForEach(breakTimeOptions, id: \.self) {
                        Text("\($0) minutes")
                    }
                }
                .disabled(inSession)
                .onChange(of: breakTime) { _ in
                    UserDefaults.standard.set(breakTime * 60, forKey: "breakTime")
                }
                
                Picker("Long break time", selection: $longBreakTime) {
                    ForEach(longBreakTimeOptions, id: \.self) {
                        Text("\($0) minutes")
                    }
                }
                .disabled(inSession)
                .onChange(of: longBreakTime) { _ in
                    UserDefaults.standard.set(longBreakTime * 60, forKey: "longBreakTime")
                }
                
                Picker("Completion sound", selection: $soundName) {
                    ForEach(soundNames, id: \.self) {
                        Text($0)
                    }
                }
                .disabled(inSession)
                .onChange(of: soundName) { _ in
                    AudioServicesPlaySystemSound((SystemSounds.all.first(where: { $0.title == soundName }))!.id)
                }
                
                Stepper(value: $sessionsUntilLongBreak, label: {
                    Text("Sessions: \(sessionsUntilLongBreak)")
                })
                .disabled(inSession)
                .onChange(of: sessionsUntilLongBreak) { _ in
                    UserDefaults.standard.set(sessionsUntilLongBreak, forKey: "sessionsUntilLongBreak")
                }
                
                
            }, header: {
                Text("Timings")
            }, footer: {
                Text("This is the number of study sessions before you start your long break.")
            })
            
            Section(content: {
                ColorPicker("Ring", selection: $color1, supportsOpacity: true)
                    .onChange(of: color1) { _ in
                        UserDefaults.standard.setColor(color1, forKey: "color1")
                    }
                    .disabled(inSession)
                ColorPicker("Background", selection: $background, supportsOpacity: true)
                    .onChange(of: background) { _ in
                        UserDefaults.standard.setColor(background, forKey: "background")
                    }
                    .disabled(inSession)
                ColorPicker(LocalizedStringKey("Text color"), selection: $textColor, supportsOpacity: true)
                    .onChange(of: textColor) { _ in
                        UserDefaults.standard.setColor(textColor, forKey: "textColor")
                    }
                    .disabled(inSession)
            }, header: {
                Text(LocalizedStringKey("colors"))
            }, footer: {
                Text(inSession ? "Sorry, settings can't be edited during a pomodoro session. Please end your session and try again." : "")
            })
        }
        .onDisappear {
            UserDefaults.standard.set(studyTime * 60, forKey: "studyTime")
            UserDefaults.standard.set(breakTime * 60, forKey: "breakTime")
            UserDefaults.standard.set(sessionsUntilLongBreak, forKey: "sessionsUntilLongBreak")
        }
        .onAppear {
            studyTime = UserDefaults.standard.integer(forKey: "studyTime") / 60
            breakTime = UserDefaults.standard.integer(forKey: "breakTime") / 60
            sessionsUntilLongBreak = UserDefaults.standard.integer(forKey: "sessionsUntilLongBreak")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(inSession: false)
    }
}

extension Color {

    // Explicitly extracted Core Graphics color
    // for the purpose of reconstruction and persistance.
    var cgColor_: CGColor {
        UIColor(self).cgColor
    }
}

extension UserDefaults {
    func setColor(_ color: Color, forKey key: String) {
        let cgColor = color.cgColor_
        let array = cgColor.components ?? []
        set(array, forKey: key)
    }

    func color(forKey key: String) -> Color {
        guard let array = object(forKey: key) as? [CGFloat] else { return .accentColor }
        let color = CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: array)!
        return Color(color)
    }
}
