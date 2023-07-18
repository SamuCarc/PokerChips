//
//  ButtonStartGame.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 20/6/23.
//

import SwiftUI

struct ButtonStartGame: View {
    var body: some View {
        ZStack {
            Image("material_button")
                .resizable()
                .frame(width: 200, height: 65)
                .cornerRadius(22)
                .opacity(0.8)
                .zIndex(1)
            
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.6), lineWidth: 3)
                .frame(width: 199, height: 64)
                .zIndex(2)
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.white.opacity(0.1), lineWidth: 3)
                .frame(width: 205, height: 71)
                .zIndex(2)
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.white.opacity(0.1), lineWidth: 10)
                .frame(width: 205, height: 71)
                .zIndex(2)

            Text("Jugar")
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .zIndex(2)
            
        }
        .frame(width: 200, height: 70)
        .padding(.top, 5)
    }
}

struct ButtonStartGame_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Image("background")
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        }
        .padding()
        .frame(maxWidth: 620, maxHeight: 350)
        .overlay(
            ButtonStartGame(), alignment: .bottom
        )
        .previewInterfaceOrientation(.landscapeLeft)

    }
}
