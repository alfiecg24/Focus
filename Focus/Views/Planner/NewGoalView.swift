//
//  NewGoalView.swift
//  Focus
//
//  Created by Alfie on 07/09/2022.
//

import SwiftUI
struct NewGoalView: View {
    
    @Binding var allGoals: [Goal]
    
    @State var name = ""
    @State var deadline = Date.now+86400
    @State var subject = Subject(name: "", red: 0, green: 0, blue: 0)
    var subjects = try! UserDefaults.standard.getObject(forKey: "subjects", castTo: [Subject].self)
    
    var adsViewModel = AdsViewModel()
    
    @State var goalsAddedCount = UserDefaults.standard.integer(forKey: "goalsAddedCount")
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Subject", selection: $subject) {
                    ForEach(subjects, id: \.self) { item in
                        Text(item.name)
                    }
                }
                .pickerStyle(.menu)
                DatePicker("Deadline", selection: $deadline)
                Button("Submit") {
                    let goal = Goal(name: name, subject: subject, deadline: deadline, id: "\(name)\(deadline.timeIntervalSince1970)")
                    var existingGoals = try! UserDefaults.standard.getObject(forKey: "goals", castTo: [Goal].self)
                    existingGoals.append(goal)
                    try! UserDefaults.standard.setObject(existingGoals, forKey: "goals")
                    let centre = UNUserNotificationCenter.current()
                    let notificationContent = UNMutableNotificationContent()
                    notificationContent.title = "Don't forget!"
                    notificationContent.subtitle = ""
                    notificationContent.body = "1 hour remaining until the deadline for \(goal.name)"
                    notificationContent.interruptionLevel = .timeSensitive
                    let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: goal.deadline)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    print("Identifier: \(goal.id)")
                    let request = UNNotificationRequest(identifier: "\(goal.id)", content: notificationContent, trigger: trigger)
                    centre.add(request)
                    allGoals = try! UserDefaults.standard.getObject(forKey: "goals", castTo: [Goal].self)
                    if goalsAddedCount == 1 {
                        UserDefaults.standard.set(0, forKey: "goalsAddedCount")
                        adsViewModel.showInterstitial.toggle()
                    } else {
                        UserDefaults.standard.set(1, forKey: "goalsAddedCount")
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .onAppear {
                subject = subjects[0]
            }
            .navigationBarHidden(true)
        }
    }
}

struct NewGoalView_Previews: PreviewProvider {
    static var previews: some View {
        NewGoalView(allGoals: .constant([Goal]()))
    }
}
