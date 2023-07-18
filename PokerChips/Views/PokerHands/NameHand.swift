//
//  nameHand.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 4/5/23.
//

import SwiftUI

struct NameHand: View {
    var number: Int
    var title: String
    var body: some View {
        HStack {
            Text(number.description)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .frame(width: 22, height: 22)
                .background(Color.black.opacity(0.8))
                .cornerRadius(20)
                .foregroundColor(.accentColor)
                .overlay(
                    Circle()
                        .stroke(Color.accentColor, lineWidth: 2)
                        .frame(width: 23, height: 23)
                )

            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .padding(EdgeInsets(top: 3, leading: 5, bottom: 3, trailing: 5))
                .background(Color.black.opacity(0.7))
                .cornerRadius(4)
        }
    }
}

struct NameHand_Previews: PreviewProvider {
    static var previews: some View {
        NameHand(number: 1, title: "Escalera Real")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
