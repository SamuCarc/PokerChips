//
//  AddButton.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 15/6/23.
//

import SwiftUI

struct AddButton: View {
    let randomNumber =  Int.random(in: 1...28)
    @State var isAnimating: Bool = false
    var body: some View {
        HStack (spacing: 15) {
            
            ZStack {
                Circle()
                    .stroke(Color.accentColor, lineWidth: 4)
                    .frame(width: 52, height: 52)
                
                Circle()
                    .fill(.black.opacity(0.6))
                    .frame(width: 47)
                    .zIndex(2)
                
                Image("Avatar_\(randomNumber)")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(30)
                    .frame(width: 48)
                    .overlay(
                        Circle()
                            .stroke(Color.accentColor, lineWidth: 3)
                            .frame(width: 52, height: 57)
                            .scaleEffect(isAnimating ? 1.4 : 1)
                            .opacity(isAnimating ? 0 : 1)
                            .onAppear() {
                                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: false)) {
                                    isAnimating = true
                                }
                            }
                    )
                
                Image(systemName: "plus")
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                    .foregroundColor(.accentColor)
                    .zIndex(3)
            }
            
            VStack (alignment: .leading, spacing: 2) {
                Text("Añadir jugador")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
        }
        .frame(width: 180, height: 55, alignment: .leading)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.ultraThinMaterial)
                .shadow(radius: 2)
        )
        .cornerRadius(20)
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Image("background")
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        }
        .padding()
        .frame(maxWidth: 620, maxHeight: 350)
        .overlay(
            AddButton(), alignment: .bottom
        )
        .previewInterfaceOrientation(.landscapeLeft)
        .preferredColorScheme(.dark)
    }
}
