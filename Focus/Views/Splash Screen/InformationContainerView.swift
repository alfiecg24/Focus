//
//  InformationContainerView.swift
//  Focus
//
//  Created by Alfie on 09/09/2022.
//

import SwiftUI

struct InformationContainerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            InformationDetailView(title: "Study productively", subTitle: "Focus is designed to help you get your work done quickly and easily. It is the perfect counterpart for all students.", imageName: "book")

            InformationDetailView(title: "Effective technique", subTitle: "Focus uses the Pomodoro revision technique - a method that is proven to be highly effective.", imageName: "clock")

            InformationDetailView(title: "Pomodoro", subTitle: "You do a work segment, then a short break, and you do that several times until you get a longer break.", imageName: "graduationcap")
        }
        .padding(.horizontal)
    }
}
