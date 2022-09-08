//
//  PlannerView.swift
//  Focus
//
//  Created by Alfie on 05/09/2022.
//

import SwiftUI

struct PlannerView: View {
    
    // Fetch necessary values from defaults
    @State private var color1: Color = UserDefaults.standard.color(forKey: "color1")
    @State private var background: Color = UserDefaults.standard.color(forKey: "background")
    @State private var textColor: Color = UserDefaults.standard.color(forKey: "textColor")
    
    @State private var log = UserDefaults.standard.array(forKey: "log") as! [String]
    @State private var allGoals = try! UserDefaults.standard.getObject(forKey: "goals", castTo: [Goal].self)
    @State private var current = Date.now.formatted(date: .omitted, time: .standard)
    
    @State private var addingGoal = false
    @State private var addingSubject = false
    @State private var goingTo = "goal" {
        didSet {
            if goingTo == "goal" {
                addingGoal.toggle()
            } else {
                addingSubject.toggle()
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: UIColor(background)).opacity(0.3)
                    .ignoresSafeArea()
                VStack {
//                    ScrollView {
//                        VStack(alignment: .leading, spacing: 1) {
//                            ForEach(log, id: \.self) { line in
//                                HStack {
//                                    Text(line)
//                                        .font(.monospaced(.body)())
//                                    Spacer()
//                                }
//                            }
//                        }
//                        .padding()
//                    }
//                    HStack {
//                        Text(current)
//                        Spacer()
//                        Button("Clear log") {
//                            UserDefaults.standard.set(["Log start"], forKey: "log")
//                            log = UserDefaults.standard.array(forKey: "log") as! [String]
//                        }
//                    }
//                    .padding()
                    ScrollView {
                        ForEach(allGoals, id: \.self) { goal in
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color(uiColor: UIColor(background)))
                                HStack {
                                    Circle()
                                        .frame(width: 22, height: 22)
                                        .foregroundColor(Color(red: goal.subject.red, green: goal.subject.green, blue: goal.subject.blue))
                                        .padding()
                                    Text(goal.name)
                                    
                                }
                            }
                            .padding()
                        }
                    }
                }
                .sheet(isPresented: $addingGoal, content: {
                    NewGoalView()
                })
                .sheet(isPresented: $addingSubject, content: {
                    NewSubjectView()
                })
                .onAppear {
                    log = UserDefaults.standard.array(forKey: "log") as! [String]
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                        current = Date.now.formatted(date: .omitted, time: .standard)
                    }
                    // Refresh colors if changed in settings
                    color1 = UserDefaults.standard.color(forKey: "color1")
                    background = UserDefaults.standard.color(forKey: "background")
                    textColor = UserDefaults.standard.color(forKey: "textColor")
                }
            }
            .toolbar {
//                Button(action: {
//                    print("New subject")
//                    addingGoal.toggle()
//                }, label: {
//                    Label("Add subject", systemImage: "plus.circle")
//                        .foregroundColor(textColor)
//                })
//                .sheet(isPresented: $addingGoal, content: {
//                    NewGoalView()
//                })
//
                NavigationLink(destination: {
                    NewGoalView()
                }, label: {
                    Label("Add subject", systemImage: "plus.circle")
                        .foregroundColor(textColor)
                })
//                Picker("New", selection: $goingTo) {
//                    Text("New subject").tag("subject")
//                    Text("New goal").tag("goal")
//                }
            }
        }
    }
}

struct PlannerView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerView()
    }
}
