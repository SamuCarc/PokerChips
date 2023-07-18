//
//  PokerHandsView.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 4/5/23.
//

import SwiftUI

struct PokerHandsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var colorTable:ColorTable

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .fill(RadialGradient(gradient: Gradient(colors: [Color("\(colorTable.rawValue)Light"), Color("\(colorTable.rawValue)Dark")]), center: .center, startRadius:5, endRadius: 600))
                .edgesIgnoringSafeArea(.all)

            HStack {
                VStack (alignment: .leading, spacing: 4) {
                    NameHand(number: 1, title: "Escalera Real")
                    HStack (spacing: 3) {
                        CardComponent(number: .ace, type: .spades, isHidde: false)
                        CardComponent(number: .kink, type: .spades, isHidde: false)
                        CardComponent(number: .queen, type: .diamonds, isHidde: false)
                        CardComponent(number: .jack, type: .spades, isHidde: false)
                        CardComponent(number: .ten, type: .spades, isHidde: false)
                    }
                    .padding(.bottom)
                    
                    NameHand(number: 2, title: "Escalera de Color")
                    HStack (spacing: 3) {
                        CardComponent(number: .ten, type: .hearts, isHidde: false)
                        CardComponent(number: .nine, type: .hearts, isHidde: false)
                        CardComponent(number: .eight, type: .hearts, isHidde: false)
                        CardComponent(number: .seven, type: .hearts, isHidde: false)
                        CardComponent(number: .six, type: .hearts, isHidde: false)
                    }
                    .padding(.bottom)

                    
                    NameHand(number: 3, title: "Poker")
                    HStack (spacing: 3) {
                        CardComponent(number: .queen, type: .hearts, isHidde: false)
                        CardComponent(number: .queen, type: .spades, isHidde: false)
                        CardComponent(number: .queen, type: .diamonds, isHidde: false)
                        CardComponent(number: .queen, type: .clubs, isHidde: false)
                        CardComponent(number: .five, type: .hearts, isHidde: true)
                    }
                    .padding(.bottom)
                    
                    NameHand(number: 4, title: "Full")
                    HStack (spacing: 3) {
                        CardComponent(number: .ace, type: .diamonds, isHidde: false)
                        CardComponent(number: .ace, type: .spades, isHidde: false)
                        CardComponent(number: .ace, type: .hearts, isHidde: false)
                        CardComponent(number: .seven, type: .clubs, isHidde: false)
                        CardComponent(number: .seven, type: .diamonds, isHidde: false)
                    }
                    .padding(.bottom)

                }//:VSTACK
                .frame(maxWidth: .infinity)
                .padding()
                Divider()
                    .overlay(Color.accentColor.opacity(0.5))
                VStack (alignment: .leading, spacing: 4) {
                    NameHand(number: 5, title: "Color")
                    HStack (spacing: 3) {
                        CardComponent(number: .ace, type: .diamonds, isHidde: false)
                        CardComponent(number: .jack, type: .diamonds, isHidde: false)
                        CardComponent(number: .eight, type: .diamonds, isHidde: false)
                        CardComponent(number: .five, type: .diamonds, isHidde: false)
                        CardComponent(number: .seven, type: .diamonds, isHidde: false)
                    }
                    .padding(.bottom)
                    
                    NameHand(number: 6, title: "Escalera")
                    HStack (spacing: 3) {
                        CardComponent(number: .ten, type: .hearts, isHidde: false)
                        CardComponent(number: .nine, type: .spades, isHidde: false)
                        CardComponent(number: .eight, type: .diamonds, isHidde: false)
                        CardComponent(number: .seven, type: .clubs, isHidde: false)
                        CardComponent(number: .six, type: .spades, isHidde: false)
                    }
                    .padding(.bottom)

                    
                    NameHand(number: 7, title: "Trio")
                    HStack (spacing: 3) {
                        CardComponent(number: .queen, type: .hearts, isHidde: false)
                        CardComponent(number: .queen, type: .spades, isHidde: false)
                        CardComponent(number: .queen, type: .diamonds, isHidde: false)
                        CardComponent(number: .seven, type: .clubs, isHidde: true)
                        CardComponent(number: .six, type: .spades, isHidde: true)
                    }
                    .padding(.bottom)
                    
                    NameHand(number: 8, title: "Doble Pareja")
                    HStack (spacing: 3) {
                        CardComponent(number: .jack, type: .hearts, isHidde: false)
                        CardComponent(number: .jack, type: .clubs, isHidde: false)
                        CardComponent(number: .nine, type: .diamonds, isHidde: false)
                        CardComponent(number: .nine, type: .clubs, isHidde: false)
                        CardComponent(number: .two, type: .diamonds, isHidde: true)
                    }
                    .padding(.bottom)

                }//:VSTACK
                .frame(maxWidth: .infinity)
                .padding()

                Divider()
                    .overlay(Color.accentColor.opacity(0.5))

                VStack (alignment: .leading, spacing: 4) {
                    NameHand(number: 9, title: "Pareja")
                    HStack (spacing: 3) {
                        CardComponent(number: .queen, type: .spades, isHidde: false)
                        CardComponent(number: .queen, type: .hearts, isHidde: false)
                        CardComponent(number: .six, type: .hearts, isHidde: true)
                        CardComponent(number: .nine, type: .clubs, isHidde: true)
                        CardComponent(number: .two, type: .diamonds, isHidde: true)
                    }
                    .padding(.bottom)
                    
                    NameHand(number: 10, title: "Carta Alta")
                    HStack (spacing: 3) {
                        CardComponent(number: .ace, type: .hearts, isHidde: false)
                        CardComponent(number: .queen, type: .spades, isHidde: true)
                        CardComponent(number: .six, type: .spades, isHidde: true)
                        CardComponent(number: .five, type: .diamonds, isHidde: true)
                        CardComponent(number: .ten, type: .clubs, isHidde: true)
                    }
                    .padding(.bottom)

                }//:VSTACK
                .frame(maxWidth: .infinity)
                .padding()

            }//:HSTACK
            .frame(maxWidth: .infinity)
            .overlay(
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
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
                .padding(), alignment: .topTrailing
        )
        }
    }
}

struct PokerHandsView_Previews: PreviewProvider {
    static var previews: some View {
        PokerHandsView(colorTable: .constant(.red))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
