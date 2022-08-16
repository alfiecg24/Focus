//
//  ClockView.swift
//  Pomodoro
//
//  Created by Alfie on 14/08/2022.
//

import SwiftUI

struct Clock: View {
    var counter: Int
    var countTo: Int
    var textColor: Color
    
    var body: some View {
        VStack {
            Text(counterToMinutes())
                .font(.custom("Avenir Next", size: 60))
                .fontWeight(.black)
                .foregroundColor(textColor)
        }
    }
    
    // Converts time remaining to readable text
    func counterToMinutes() -> String {
        let currentTime = countTo - counter
        let seconds = currentTime % 60
        let minutes = Int(currentTime / 60)
        
        return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
    }
    
}
