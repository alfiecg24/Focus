//
//  PlannerView.swift
//  Focus
//
//  Created by Alfie on 05/09/2022.
//

import SwiftUI
import AlertToast



struct PlannerView: View {
    
    // Fetch necessary values from defaults
    @State private var color1: Color = UserDefaults.standard.color(forKey: "color1")
    @State private var background: Color = UserDefaults.standard.color(forKey: "background")
    @State private var textColor: Color = UserDefaults.standard.color(forKey: "textColor")
    
    @State private var log = UserDefaults.standard.array(forKey: "log") as! [String]
    @State var allGoals = [Goal]()
    @State private var current = Date.now.formatted(date: .omitted, time: .standard)
    
    @State private var addingGoal = false
    @State private var addingSubject = false
    
    @State private var cachedGoal: Goal? = nil
    @State private var hasJustDeleted = false
    @State private var isShowingToast = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: UIColor(background))
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
                    if allGoals.count >= 1 {
                        ScrollView {
                            ForEach(allGoals, id: \.self) { goal in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
    //                                    .foregroundColor(Color(uiColor: UIColor(color1)))
                                        .opacity(0.3)
                                        .foregroundColor(Color.secondary)
                                    HStack {
                                        Circle()
                                            .frame(width: 33, height: 33)
                                            .foregroundColor(Color(red: goal.subject.red, green: goal.subject.green, blue: goal.subject.blue))
                                            .padding()
                                        VStack(alignment: .leading) {
                                            Text(goal.name)
                                                .font(.custom("Avenir Next", size: 18))
                                            Text(goal.deadline.formatted(date: .numeric, time: .shortened))
                                                .font(.custom("Avenir Next", size: 14))
                                            
                                        }
                                        .foregroundColor(textColor)
                                        .padding(.leading)
                                        Spacer()
                                    }
                                    .padding()
                                }
                                .padding()
                                .onLongPressGesture(minimumDuration: 0.5, perform: {
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                    cachedGoal = goal
                                    removeGoal(allGoals.firstIndex(where: {$0.name == goal.name && $0.deadline == goal.deadline})!)
                                    hasJustDeleted = true
                                    isShowingToast.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                        hasJustDeleted = false
                                    }
                                })
                            }
                        }
                    } else {
                        Text("No goals to display!")
                            .font(.custom("Avenir Next", size: 40))
                            .foregroundColor(.white)
                    }
                    VStack {
                        HStack {
                            Button("Add subject") {
                                addingSubject.toggle()
                            }
                            .foregroundColor(textColor)
                            .buttonStyle(.bordered)
                            .frame(width: 150)
                            Button("Add goal") {
                                addingGoal.toggle()
                            }
                            .foregroundColor(textColor)
                            .buttonStyle(.bordered)
                            .frame(width: 150)
                        }
                        Text("Press and hold on a goal to delete it")
                            .font(.custom("Avenir Next", size: 17))
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                .toast(isPresenting: $isShowingToast){
                    AlertToast(displayMode: .hud, type: .complete(.green), title: "Goal complete!")
                }
                .sheet(isPresented: $addingGoal, content: {
                    NewGoalView(allGoals: $allGoals)
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
            .onAppear {
                do {
                    allGoals = try UserDefaults.standard.getObject(forKey: "goals", castTo: [Goal].self).sorted(by: {$0.deadline < $1.deadline})
                    for goal in allGoals {
                        if goal.deadline < Date.now {
                            let centre = UNUserNotificationCenter.current()
                            centre.removePendingNotificationRequests(withIdentifiers: [goal.id])
                            var goals = try! UserDefaults.standard.getObject(forKey: "goals", castTo: [Goal].self).sorted(by: {$0.deadline < $1.deadline})
                            goals.remove(at: allGoals.firstIndex(where: {$0.name == goal.name && $0.deadline == goal.deadline})!)
                            
                            do {
                                try UserDefaults.standard.setObject(goals, forKey: "goals")
                            } catch {
                                print("No goals")
                            }
                            
                            withAnimation {
                                allGoals = try! UserDefaults.standard.getObject(forKey: "goals", castTo: [Goal].self).sorted(by: {$0.deadline < $1.deadline})
                            }
                            
                        }
                    }
                } catch {
                    print("No goals!")
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        undoRemove()
                        hasJustDeleted = false
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.warning)
                    }, label: {
                        Image(systemName: hasJustDeleted ? "arrow.uturn.backward.circle" : "")
                            .foregroundColor(textColor)
                    })
                    .disabled(!hasJustDeleted)
                })
            }
        }
        .navigationViewStyle(.stack)
    }
    func removeGoal(_ index: Int) {
        let goal = allGoals[index]
        var goals = try! UserDefaults.standard.getObject(forKey: "goals", castTo: [Goal].self).sorted(by: {$0.deadline < $1.deadline})
        goals.remove(at: index)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [goal.id])
        try! UserDefaults.standard.setObject(goals, forKey: "goals")
        withAnimation {
            allGoals = try! UserDefaults.standard.getObject(forKey: "goals", castTo: [Goal].self).sorted(by: {$0.deadline < $1.deadline})
        }
        
    }

    func undoRemove() {
        var goals = try! UserDefaults.standard.getObject(forKey: "goals", castTo: [Goal].self).sorted(by: {$0.deadline < $1.deadline})
        if cachedGoal != nil {
            goals.append(cachedGoal!)
            try! UserDefaults.standard.setObject(goals, forKey: "goals")
            withAnimation {
                allGoals = try! UserDefaults.standard.getObject(forKey: "goals", castTo: [Goal].self).sorted(by: {$0.deadline < $1.deadline})
            }
            let goal = cachedGoal
            let centre = UNUserNotificationCenter.current()
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "Don't forget!"
            notificationContent.subtitle = ""
            notificationContent.body = "1 hour remaining until the deadline for \(goal!.name)"
            notificationContent.interruptionLevel = .timeSensitive
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: goal!.deadline)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            print("Identifier: \(goal!.id)")
            let request = UNNotificationRequest(identifier: "\(goal!.id)", content: notificationContent, trigger: trigger)
            centre.add(request)
        }
    }
}

struct PlannerView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerView()
    }
}
