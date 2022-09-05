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
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: UIColor(background))
                    .ignoresSafeArea()
                Text("Hello world")
                    .foregroundColor(textColor)
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
