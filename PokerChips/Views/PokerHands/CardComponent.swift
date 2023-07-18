//
//  Card.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 4/5/23.
//

import SwiftUI

enum Numbers:Int {
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case ten = 10
    case jack = 11
    case queen = 12
    case kink = 13
    case ace = 14
    
    var name:String {
        switch self {
        case .two, .three, .four, .five, .six, .seven, .eight, .nine, .ten:
            return self.rawValue.description
        case .jack:
            return "J"
        case .queen:
            return "Q"
        case .kink:
            return "K"
        case .ace:
            return "A"
        }
    }
}

enum cardTypes {
    case hearts
    case diamonds
    case clubs
    case spades
    
    var color: Color {
        switch self {
        case .hearts, .diamonds:
            return .red
        case .clubs, .spades:
            return .black
        }
    }
    
    var imageName: String {
        switch self {
        case .hearts:
            return "heart.fill"
        case .diamonds:
            return "diamond.fill"
        case .clubs:
            return "suit.club.fill"
        case .spades:
            return "suit.spade.fill"
        }
    }
}
    
struct CardComponent: View {
    var number: Numbers
    var type: cardTypes
    var isHidde: Bool
    var size: CGFloat = 1
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.white)
                .shadow(radius: size * 2.5)
                .zIndex(1)
            


            if isHidde {
                RoundedRectangle(cornerRadius: size * 2.5)
                    .foregroundColor(.black)
                    .opacity(0.6)
                    .zIndex(3)
            }

            VStack (spacing: 0) {
                Text(number.name)
                    .foregroundColor(type.color)
                    .font(.system(size: size * 14, weight: .bold, design: .rounded))

                
                Image(systemName: type.imageName)
                    .foregroundColor(type.color)
                    .font(.system(size: size * 14))
                    .zIndex(2)

            }//:VSTACK
            .zIndex(2)
        }//:ZSTACK
        .frame(width: size * 30, height: size * 40)
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        VStack (spacing: 3) {
            HStack (spacing: 3) {
                CardComponent(number: .kink, type: .diamonds, isHidde: false)
                CardComponent(number: .kink, type: .clubs, isHidde: false)
                CardComponent(number: .queen, type: .diamonds, isHidde: false)
                CardComponent(number: .queen, type: .spades, isHidde: false)
                CardComponent(number: .two, type: .hearts, isHidde: true)
            }

            HStack (spacing: 3) {
                CardComponent(number: .nine, type: .hearts, isHidde: false)
                CardComponent(number: .nine, type: .spades, isHidde: false)
                CardComponent(number: .ten, type: .diamonds, isHidde: true)
                CardComponent(number: .two, type: .hearts, isHidde: true)
                CardComponent(number: .two, type: .hearts, isHidde: true)
            }
            
            HStack (spacing: 3) {
                CardComponent(number: .ace, type: .hearts, isHidde: false)
                CardComponent(number: .two, type: .hearts, isHidde: true)
                CardComponent(number: .two, type: .hearts, isHidde: true)
                CardComponent(number: .two, type: .hearts, isHidde: true)
                CardComponent(number: .two, type: .hearts, isHidde: true)
            }

        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
