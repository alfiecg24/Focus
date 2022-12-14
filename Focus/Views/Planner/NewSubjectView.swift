//
//  NewSubjectView.swift
//  Focus
//
//  Created by Alfie on 07/09/2022.
//

import SwiftUI

struct NewSubjectView: View {
    @State private var name = ""
    @State var colour = Color("Background")
    @State private var subjects: [Subject] = try! UserDefaults.standard.getObject(forKey: "subjects", castTo: [Subject].self)
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
            ColorPicker("Subject color", selection: $colour, supportsOpacity: true)
            Button("Submit") {
                let newSubject = Subject(name: name, red: UIColor(colour).rgba.red, green: UIColor(colour).rgba.green, blue: UIColor(colour).rgba.blue)
                subjects.append(newSubject)
                try! UserDefaults.standard.setObject(subjects, forKey: "subjects")
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct NewSubjectView_Previews: PreviewProvider {
    static var previews: some View {
        NewSubjectView()
    }
}
