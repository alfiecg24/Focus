//
//  SplashScreenView.swift
//  Focus
//
//  Created by Alfie on 09/09/2022.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isFinished = false
    var body: some View {
        VStack(alignment: .center) {
            
            Spacer()
            
            TitleView()
            
            InformationContainerView()
            
            Spacer()
            
            Button(action: {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                isFinished.toggle()
                UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            }) {
                Text("Continue")
                    .customButton()
            }
            .padding(.horizontal)
            .fullScreenCover(isPresented: $isFinished, content: {
                TabView {
                    MainView()
                        .tabItem({
                            Label("Timer", systemImage: "deskclock")
                        })
                    PlannerView()
                        .tabItem({
                            Label("Planner", systemImage: "calendar.day.timeline.left")
                        })
                }
            })
            
            Spacer()
        }
    }
}
