//
//  ButtonAllIn.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 8/5/23.
//

import SwiftUI

struct ButtonAllIn: View {
    @Binding var raise: Int

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 90, height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color.red.opacity(0.1))
                )
                .foregroundStyle(.ultraThinMaterial)
                .shadow(radius: 2)

            VStack {
                Text("All In \(Image(systemName: "dollarsign"))")
                    .font(.system(size: 14, weight: .black, design: .rounded))
                .foregroundColor(.red)
                Text(formatCurrency(amount: raise))
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundColor(.white)
            }
        }
    }
}

struct ButtonAllIn_Previews: PreviewProvider {
    static var previews: some View {
        ButtonAllIn(raise: .constant(8450))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
