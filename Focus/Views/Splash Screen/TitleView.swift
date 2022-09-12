//
//  TitleView.swift
//  Focus
//
//  Created by Alfie on 09/09/2022.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        VStack {
            Image(UITraitCollection().userInterfaceStyle == .dark ? "LogoNoBG" : "LogoNoBGBlue")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, alignment: .center)
                .accessibility(hidden: true)

            Text("Welcome to")
                .customTitleText()

            Text("Focus")
                .customTitleText()
                .foregroundColor(.mainColor)
        }
    }
}
