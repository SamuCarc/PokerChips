//
//  DeletePlayer.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 19/6/23.
//

import SwiftUI

struct DeletePlayer: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .fill(
                    LinearGradient(gradient: Gradient(colors: [.black, .accentColor.opacity(0.5)]), startPoint: .bottom, endPoint: .top)
                )
                .frame(width:55, height: 55)
                .shadow(radius: 4)


            Image(systemName: "person.crop.circle.fill.badge.minus")
                .font(.system(size: 30, weight: .regular, design: .rounded))
                .foregroundColor(.accentColor)
                .padding()
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.accentColor, lineWidth: 5)
                        .frame(width:55, height: 55)
                )
        }
    }
}

struct DeletePlayer_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Image("background")
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        }
        .padding()
        .frame(maxWidth: 620, maxHeight: 350)
        .overlay(
            DeletePlayer()
                .padding(.horizontal, 40)
            , alignment: .topTrailing
        )
        .previewInterfaceOrientation(.landscapeLeft)
        .preferredColorScheme(.dark)
    }
}
