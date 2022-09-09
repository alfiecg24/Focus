//
//  Data.swift
//  Focus
//
//  Created by Alfie on 09/09/2022.
//

import UIKit
import SwiftUI

struct PageData {
    let title: String
    let header: String
    let content: String
    let imageName: String
    let color: Color
    let textColor: Color
}

struct SplashData {
    static let pages: [PageData] = [
        PageData(
            title: "Focus",
            header: "",
            content: "A revision timer to help you study productively",
            imageName: "circle",
            color: Color("Background"),
            textColor: .white),
        PageData(
            title: "Efficient studying",
            header: "",
            content: "Focus is based off of the Pomodoro technique",
            imageName: "book",
            color: Color.green,
            textColor: .white),
        PageData(
            title: "Pomodoro",
            header: "",
            content: "A study technique proven to be highly effective",
            imageName: "clock",
            color: Color.orange,
            textColor: .white),
        PageData(
            title: "Enjoy!",
            header: "",
            content: "",
            imageName: "iphone",
            color: Color("Background"),
            textColor: .white),
    ]
}

/// Color converter from hex string to SwiftUI's Color
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}
