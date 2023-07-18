//
//  Background.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 17/5/23.
//

import SwiftUI

enum ColorTable:String,CaseIterable {
    case green = "PokerGreen"
    case red = "PokerRed"
    case blue = "PokerBlue"
    case pink = "PokerPink"
    case white = "PokerWhite"
    case black = "PokerBlack"
}

struct Background: View {
    @Binding var colorTable:ColorTable
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .fill(RadialGradient(gradient: Gradient(colors: [.black, colorTable == .white ? Color("PokerBlackLight") :Color("\(colorTable.rawValue)Light")]), center: .center, startRadius:5, endRadius: 700))
                .edgesIgnoringSafeArea(.all)

            ZStack {
                RoundedRectangle(cornerRadius: 250)
                    .strokeBorder(colorTable == .white ? Color.black.opacity(0.05) : Color.white.opacity(0.05), lineWidth: 3)
                    .zIndex(1)
                    .padding(80)

                RoundedRectangle(cornerRadius: 250)
                    .strokeBorder(Color.black.opacity(0.05), lineWidth: 2)
                    .zIndex(2)
                    .shadow(radius: 10)

                RoundedRectangle(cornerRadius: 250)
                    .strokeBorder(                   RadialGradient(gradient: Gradient(colors: [Color("PokerGray"), Color("PokerGray").opacity(0.9)]), center: .center, startRadius: 5, endRadius: 500), lineWidth: 20)
                    .zIndex(1)
                    .shadow(radius: 10)
                
                RoundedRectangle(cornerRadius: 250)
                    .strokeBorder(RadialGradient(gradient: Gradient(colors: [Color("WoodLight"), Color("WoodDark")]), center: .center, startRadius: 5, endRadius: 500), lineWidth: 15)
                    .background(
                        RoundedRectangle(cornerRadius: 250)
                            .fill(
                                RadialGradient(gradient: Gradient(colors: [Color("\(colorTable.rawValue)Light"), Color("\(colorTable.rawValue)Dark")]), center: .center, startRadius: 5, endRadius: 500)
                            )
                            .shadow(radius: 30)
                    )
                    .shadow(radius: 10)
                    .padding(20)
            }
            .padding(.horizontal, 50)
            .padding(.vertical, 30)
        }
    }
}

struct Background_Previews: PreviewProvider {
    static var previews: some View {
        Background(colorTable: .constant(.blue))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
