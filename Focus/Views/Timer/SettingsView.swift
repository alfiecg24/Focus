//
//  SettingsView.swift
//  Pomodoro
//
//  Created by Alfie on 14/08/2022.
//

import SwiftUI
import AVFoundation

struct SettingsView: View {
    // Fetch initial values from UserDefaults
    @State private var studyTime = UserDefaults.standard.integer(forKey: "studyTime") / 60
    @State private var breakTime = UserDefaults.standard.integer(forKey: "breakTime") / 60
    @State private var longBreakTime = UserDefaults.standard.integer(forKey: "longBreakTime") / 60
    @State private var sessionsUntilLongBreak = UserDefaults.standard.integer(forKey: "sessionsUntilLongBreak")
    @State private var color1: Color = UserDefaults.standard.color(forKey: "color1")
    @State private var background: Color = UserDefaults.standard.color(forKey: "background")
    @State private var textColor: Color = UserDefaults.standard.color(forKey: "textColor")
    @State private var workSegmentName: String = UserDefaults.standard.string(forKey: "workSegmentName")!
    
    // Passed to view from MainView
    let inSession: Bool
    
    // Picker Options
    let studyTimeOptions = [10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]
    let breakTimeOptions = [5, 10, 15, 20, 25, 30]
    let longBreakTimeOptions = [15, 20, 25, 30, 35, 40, 45]
    
    var body: some View {
        ZStack {
            Form {
                Section(content: {
                    TextField("Work segment name", text: $workSegmentName)
                        .onChange(of: workSegmentName) { _ in
                            UserDefaults.standard.set(workSegmentName, forKey: "workSegmentName")
                        }
                }, header: {
                    Text("Segment names")
                }, footer: {
                    Text("The name of the work segment.")
                })
                Section(content: {
                    /*
                     
                     Picker("Setting", selection: $settingBeingEdited) {
                         // Shows all possible options for user to choose from
                         ForEach(settingOptions, id: \.self) {
                             Text("\($0)")
                         }
                     }
                     // Save any changed to UserDefaults immediately
                     .onChange(of: settingBeingEdited) { _ in
                         UserDefaults.standard.set(settingBeingEdited, forKey: "settingBeingEdited")
                     }
                     
                     */
                    
                    Picker("Study time", selection: $studyTime) {
                        
                        ForEach(studyTimeOptions, id: \.self) {
                            Text("\($0) minutes")
                        }
                    }
                    .onChange(of: studyTime) { _ in
                        UserDefaults.standard.set(studyTime * 60, forKey: "studyTime")

                    }
                    Picker("Break time", selection: $breakTime) {
                        ForEach(breakTimeOptions, id: \.self) {
                            Text("\($0) minutes")
                        }
                    }
                    .onChange(of: breakTime) { _ in
                        UserDefaults.standard.set(breakTime * 60, forKey: "breakTime")
                    }
                    
                    Picker("Long break time", selection: $longBreakTime) {
                        ForEach(longBreakTimeOptions, id: \.self) {
                            Text("\($0) minutes")
                        }
                    }
                    .onChange(of: longBreakTime) { _ in
                        UserDefaults.standard.set(longBreakTime * 60, forKey: "longBreakTime")
                    }
                    
                    Stepper(value: $sessionsUntilLongBreak, label: {
                        Text("Sessions: \(sessionsUntilLongBreak)")
                    })
                    .onChange(of: sessionsUntilLongBreak) { _ in
                        UserDefaults.standard.set(sessionsUntilLongBreak, forKey: "sessionsUntilLongBreak")
                    }
                    
                    
                }, header: {
                    Text("Timings")
                }, footer: {
                    // Explanation for final setting
                    Text("This is the number of study sessions before you start your long break.")
                })
                .disabled(inSession)
                
                Section(content: {
                    
                    /*
                                // Localised for 'color'/'colour'
                     ColorPicker(LocalizedStringKey("Text color"), selection: $textColor, supportsOpacity: true)
                        // Updates value when changed
                         .onChange(of: textColor) { _ in
                             UserDefaults.standard.setColor(textColor, forKey: "textColor")
                         }
                     
                     */
                    
                    ColorPicker("Ring", selection: $color1, supportsOpacity: true)
                        .onChange(of: color1) { _ in
                            UserDefaults.standard.setColor(color1, forKey: "color1")
                        }
                    ColorPicker("Background", selection: $background, supportsOpacity: true)
                        .onChange(of: background) { _ in
                            UserDefaults.standard.setColor(background, forKey: "background")
                        }
                    ColorPicker(LocalizedStringKey("Text color"), selection: $textColor, supportsOpacity: true)
                        .onChange(of: textColor) { _ in
                            UserDefaults.standard.setColor(textColor, forKey: "textColor")
                        }
                }, header: {
                    Text(LocalizedStringKey("colors"))
                }, footer: {
                    Text(inSession ? "Sorry, settings can't be edited during a pomodoro session. Please end your session and try again." : "")
                })
                .disabled(inSession)
            }
//            VStack(alignment: .center) {
//                Spacer()
//                GADBannerViewController()
////                    .border(.green)
//                    .frame(height: 75)
//                
//            }
        }
        // Just to be sure ;)
        .onDisappear {
            UserDefaults.standard.set(studyTime * 60, forKey: "studyTime")
            UserDefaults.standard.set(breakTime * 60, forKey: "breakTime")
            UserDefaults.standard.set(sessionsUntilLongBreak, forKey: "sessionsUntilLongBreak")
            UserDefaults.standard.set(workSegmentName, forKey: "workSegmentName")
        }
        .onAppear {
            studyTime = UserDefaults.standard.integer(forKey: "studyTime") / 60
            breakTime = UserDefaults.standard.integer(forKey: "breakTime") / 60
            sessionsUntilLongBreak = UserDefaults.standard.integer(forKey: "sessionsUntilLongBreak")
            workSegmentName = UserDefaults.standard.string(forKey: "workSegmentName")!
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
