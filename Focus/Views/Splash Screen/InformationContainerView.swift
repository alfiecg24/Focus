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

            InformationDetailView(title: "Efficient revision", subTitle: "Focus can help you get the most out of your revision by making sure you are working productively at all times.", imageName: "clock")

            InformationDetailView(title: "Effective technique", subTitle: "Focus uses the Pomodoro revision technique - a method that is proven to be highly effective.", imageName: "graduationcap")
        }
        .padding(.horizontal)
    }
}
