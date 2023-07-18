//
//  ButtonCall.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 8/5/23.
//

import SwiftUI

struct ButtonCall: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 90, height: 60)
                .foregroundStyle(.ultraThinMaterial)
                .shadow(radius: 2)
            Text("Igualar \(Image(systemName: "checkmark.circle.fill"))")
                .font(.system(size: 14, weight: .black, design: .rounded))
                .foregroundColor(.accentColor)
        }
    }
}


struct ButtonCall_Previews: PreviewProvider {
    static var previews: some View {
        ButtonCall()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
