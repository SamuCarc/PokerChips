//
//  ButtonAccentColor.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 8/5/23.
//

import SwiftUI

struct ButtonPokerHands: View {
    var body: some View {
        Image(systemName: "suit.club.fill")
            .font(.system(size: 20, weight: .regular, design: .rounded))
            .foregroundColor(.accentColor)
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.accentColor.opacity(0.8), lineWidth: 3)
            )
    }
}

struct ButtonPokerHands_Previews: PreviewProvider {
    static var previews: some View {
        ButtonPokerHands()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
