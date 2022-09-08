//
//  NewGoalView.swift
//  Focus
//
//  Created by Alfie on 07/09/2022.
//

import SwiftUI
struct NewGoalView: View {
    @State private var name = ""
    @State private var deadline = Date.now+86400
    @State private var subject = Subject(name: "", red: 0, green: 0, blue: 0)
    private var subjects = try! UserDefaults.standard.getObject(forKey: "subjects", castTo: [Subject].self)
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Subject", selection: $subject) {
                    ForEach(subjects, id: \.self) { item in
                        Text(item.name)
                    }
                }
                DatePicker("Deadline", selection: $deadline)
                Button("Finish") {
                    let goal = Goal(name: name, subject: subject, deadline: deadline)
                    var existingGoals = try! UserDefaults.standard.getObject(forKey: "goals", castTo: [Goal].self)
                    existingGoals.append(goal)
                    try! UserDefaults.standard.setObject(existingGoals, forKey: "goals")
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
        NewGoalView()
    }
}
