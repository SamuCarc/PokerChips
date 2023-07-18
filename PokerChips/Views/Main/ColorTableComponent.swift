//
//  ColorTableComponent.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 20/6/23.
//

import SwiftUI

struct ColorTableComponent: View {
    var colorTable:ColorTable
    @Binding var isSelected: Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(RadialGradient(gradient: Gradient(colors: [.black, Color("\(colorTable.rawValue)Dark")]), center: .center, startRadius: isSelected ? 150 : 70, endRadius: 0))
                .frame(width: 40, height: 40)
            .zIndex(2)

            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.accentColor.opacity(1), lineWidth: 3)
                .frame(width: 40, height: 40)
            .zIndex(2)
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.accentColor.opacity(0.4), lineWidth: 4)
                .frame(width: 44, height: 44)
            .zIndex(2)
            
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: isSelected ? 8 : 0)
                .frame(width: 48, height: 48)
            .zIndex(2)
        }
        .scaleEffect(isSelected ? 1.5 : 1)

    }
}

struct ColorTableComponent_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Image("background")
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            HStack (spacing: 20) {
                ForEach(ColorTable.allCases, id: \.self) { colorTable in
                    ColorTableComponent(colorTable: colorTable, isSelected: .constant(colorTable == .green))
                }
                
            }
        }
        .padding()
        .frame(maxWidth: 620, maxHeight: 350)
        .overlay(
            Button {
                
            } label: {
                ButtonStartGame()
            }
            , alignment: .bottom
        )
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
