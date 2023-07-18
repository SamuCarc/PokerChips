//
//  SettingsIcon.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 9/5/23.
//

import SwiftUI

struct SettingsIcon: View {
    var body: some View {
        Image(systemName: "gearshape.fill")
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

struct SettingsIcon_Previews: PreviewProvider {
    static var previews: some View {
        SettingsIcon()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
