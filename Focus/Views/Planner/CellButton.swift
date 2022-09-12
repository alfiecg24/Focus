//
//  CellButton.swift
//  Focus
//
//  Created by Alfie on 12/09/2022.
//

import Foundation
import SwiftUI

let buttonWidth: CGFloat = 60

enum CellButtons: Identifiable {
    case edit
    case delete
    case save
    case info
    
    var id: String {
        return "\(self)"
    }
}

struct CellButtonView: View {
    let data: CellButtons
    let cellHeight: CGFloat
    
    func getView(for image: String, title: String) -> some View {
        VStack {
            Image(systemName: image)
            Text(title)
        }
        .padding(5)
        .foregroundColor(.primary)
        .font(.subheadline)
        .frame(width: buttonWidth, height: cellHeight)
    }
    
    var body: some View {
        switch data {
        case .edit:
            getView(for: "pencil.circle", title: "Edit")
                .background(Color.pink)
        case .delete:
            getView(for: "delete.right", title: "Delete")
                .background(Color.red)
        case .save:
            getView(for: "square.and.arrow.down", title: "Save")
                .background(Color.blue)
        case .info:
            getView(for: "info.circle", title: "Info")
                .background(Color.green)
        }
    }
}
