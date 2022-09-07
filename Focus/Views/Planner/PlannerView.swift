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
    @State private var current = Date.now.formatted(date: .omitted, time: .standard)
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: UIColor(background))
                    .ignoresSafeArea()
                VStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 1) {
                            ForEach(log, id: \.self) { line in
                                HStack {
                                    Text(line)
                                        .font(.monospaced(.body)())
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                    }
                    HStack {
                        Text(current)
                        Spacer()
                        Button("Clear log") {
                            UserDefaults.standard.set(["Log start"], forKey: "log")
                            log = UserDefaults.standard.array(forKey: "log") as! [String]
                        }
                    }
                    .padding()
                }
                .onAppear {
                    log = UserDefaults.standard.array(forKey: "log") as! [String]
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                        current = Date.now.formatted(date: .omitted, time: .standard)
                    }
                }
            }
                .toolbar {
                    Button(action: {
                        print("New subject")
                    }, label: {
                        Label("Add subject", systemImage: "plus.circle")
                            .foregroundColor(textColor)
                    })
                }
        }
    }
}

struct PlannerView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerView()
    }
}
