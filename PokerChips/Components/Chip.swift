//
//  Chip.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 4/5/23.
//

import SwiftUI

enum PokerChip: Int, CaseIterable {
    case white = 1
    case red = 5
    case blue = 10
    case green = 25
    case black = 100
    case purple = 500
    case yellow = 1000
    case pink = 5000
    case orange = 10000
    case accentColor = 50000

    var value: String {
        switch self {
        case .white:
            return "1"
        case .red:
            return "5"
        case .blue:
            return "10"
        case .green:
            return "25"
        case .black:
            return "100"
        case .purple:
            return "500"
        case .yellow:
            return "1K"
        case .pink:
            return "5K"
        case .orange:
            return "10K"
        case .accentColor:
            return "50K"

        }
    }

    var color: Color {
        switch self {
        case .white:
            return .white
        case .red:
            return .red
        case .blue:
            return .blue
        case .green:
            return .green
        case .black:
            return .black
        case .purple:
            return .purple
        case .yellow:
            return .yellow
        case .pink:
            return .pink
        case .orange:
            return .orange
        case .accentColor:
            return .accentColor
        }
    }
}

struct Chip: View {
    let chip: PokerChip
    let count: Int

    var body: some View {
        ZStack {
            ForEach(0..<count, id: \.self) { index in
                Circle()
                    .fill(chip.color)
                    .frame(width: 8, height: 8)
                    .shadow(radius: 0.1)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 0.4)
                            .shadow(color: .black, radius:  0.1)
                    )
                    .overlay(
                        Circle()
                            .trim(from: 0.0, to: 0.1)
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 6, height: 6)
                            .rotationEffect(Angle(degrees: 90))
                    )
                    .overlay(
                        Circle()
                            .trim(from: 0.0, to: 0.1)
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 6, height: 6)
                            .rotationEffect(Angle(degrees: 0))
                    )
                    .overlay(
                        Circle()
                            .trim(from: 0.0, to: 0.1)
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 6, height: 6)
                            .rotationEffect(Angle(degrees: 180))
                    )
                    .overlay(
                        Circle()
                            .trim(from: 0.0, to: 0.1)
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 6, height: 6)
                            .rotationEffect(Angle(degrees: 270))
                    )
                    .overlay(
                        Circle()
                            .fill(Color.black)
                            .frame(width: 3.5, height: 3.5)
                    )
                    .offset(x: 0, y: CGFloat(index) * -1)
            }
        }
    }
}

func exampleChips() -> [Chip] {
    let totalAmount:Int = 633569
    let chipsNeeded = chipsForAmount(totalAmount)
    return chipsNeeded.map { Chip(chip: $0.key, count: $0.value) }
}

struct Chip_Previews: PreviewProvider {
    static var previews: some View {
        let columns = [
            GridItem(.adaptive(minimum: 0))
        ]
        
        LazyVGrid(columns: columns, alignment: .center, spacing: 0) {
            ForEach(exampleChips(), id: \.chip) { chipView in
                chipView
            }
        }
        .frame(width: 16, height: 16)
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
