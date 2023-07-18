//
//  ButtonCheck.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 8/5/23.
//

import SwiftUI

struct ButtonCheck: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 90, height: 60)
                .foregroundStyle(.ultraThinMaterial)
                .shadow(radius: 2)
            Text("Pasar \(Image(systemName: "arrow.right.circle.fill"))")
                .font(.system(size: 14, weight: .black, design: .rounded))
                .foregroundColor(.primary)
        }
    }
}

struct ButtonCheck_Previews: PreviewProvider {
    static var previews: some View {
        ButtonCheck()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
