//
//  Subject.swift
//  Focus
//
//  Created by Alfie on 06/09/2022.
//

import Foundation
import SwiftUI

struct Subject: Codable, Hashable {
    var name: String
    var red: Double
    var green: Double
    var blue: Double
    var opacity: Double?
}

struct Goal: Codable, Hashable {
    var name: String
    var subject: Subject
    var deadline: Date
}
