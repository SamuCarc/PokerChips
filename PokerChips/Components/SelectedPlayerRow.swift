//
//  SelectPlayer.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 15/5/23.
//

import SwiftUI

struct SelectedPlayerRow: View {
    var avatar:String
    var alias:String
    @Binding var isSelected:Bool

    let sizeAvatar:CGFloat = 90
    var body: some View {
        VStack (spacing: 2) {
            ZStack {
                Circle()
                    .stroke(Color.accentColor, lineWidth: isSelected ? 7 : 1)
                    .frame(width: sizeAvatar + 7, height: sizeAvatar + 7)

                    Circle()
                    .fill(isSelected ? .white.opacity(0.1) : .black.opacity(0.4))
                        .frame(width: sizeAvatar)
                        .zIndex(1)

                Image(avatar)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(sizeAvatar)
                    .frame(width: sizeAvatar)
            }
            Text(alias)
                .foregroundColor(.accentColor)
                .font(.system(size: 14, weight: isSelected ?.bold : .semibold, design: .rounded))
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
    }
}

struct SelectPlayer_Previews: PreviewProvider {
    static var previews: some View {
        SelectedPlayerRow(avatar: "Avatar_4", alias: "Samuel", isSelected: .constant(false))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
