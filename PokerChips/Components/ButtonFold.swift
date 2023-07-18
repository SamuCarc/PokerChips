//
//  ButtonFold.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 8/5/23.
//

import SwiftUI

struct ButtonFold: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 100, height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color.gray.opacity(0.1))
                )
                .foregroundStyle(.ultraThinMaterial)
                .shadow(radius: 2)
            Text("Retirarse \(Image(systemName: "xmark.circle.fill"))")
                .font(.system(size: 14, weight: .black, design: .rounded))
                .foregroundColor(.black)
        }
    }
}

struct ButtonFold_Previews: PreviewProvider {
    static var previews: some View {
        ButtonFold()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
