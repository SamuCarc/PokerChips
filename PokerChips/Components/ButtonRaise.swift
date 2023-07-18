//
//  ButtonRaise.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 8/5/23.
//

import SwiftUI

struct ButtonRaise: View {
    @Binding var raise: Int
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 90, height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color.accentColor.opacity(0.1))
                )
                .foregroundStyle(.ultraThinMaterial)
                .shadow(radius: 2)
            
            VStack {
                Text("Subir \(Image(systemName: "arrow.up.circle.fill"))")
                    .font(.system(size: 14, weight: .black, design: .rounded))
                .foregroundColor(.accentColor)
                Text(formatCurrency(amount: raise))
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundColor(.white)
            }
        }
    }
}

struct ButtonRaise_Previews: PreviewProvider {
    static var previews: some View {
        ButtonRaise(raise: .constant(200))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
