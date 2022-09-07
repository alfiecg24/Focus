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
    private var subjects = UserDefaults.standard.array(forKey: "subjects") as! [Subject]
    var body: some View {
        Form {
            TextField("Name", text: $name)
            Picker("Subject", selection: $subject) {
                ForEach(subjects, id: \.self) { item in
                    Text(item.name)
                }
            }
            DatePicker("Deadline", selection: $deadline)
            Button("Finish")
        }
        .onAppear {
            subject = subjects[0]
        }
    }
}

struct NewGoalView_Previews: PreviewProvider {
    static var previews: some View {
        NewGoalView()
    }
}
