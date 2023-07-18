//
//  DealerChip.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 4/5/23.
//

import SwiftUI

struct DealerChip: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 24, height: 24)
                .shadow(radius: 1)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 1)
                        .shadow(color: .black, radius: 1, x: 0, y: 0)
                )
                .overlay(
                    Circle()
                        .trim(from: 0.0, to: 0.1)
                        .stroke(Color.white, lineWidth: 5)
                        .frame(width: 19, height: 19)
                        .rotationEffect(Angle(degrees: 90))
                )
                .overlay(
                    Circle()
                        .trim(from: 0.0, to: 0.1)
                        .stroke(Color.white, lineWidth: 5)
                        .frame(width: 19, height: 19)
                        .rotationEffect(Angle(degrees: 0))
                )
                .overlay(
                    Circle()
                        .trim(from: 0.0, to: 0.1)
                        .stroke(Color.white, lineWidth: 5)
                        .frame(width: 19, height: 19)
                        .rotationEffect(Angle(degrees: 180))
                )
                .overlay(
                    Circle()
                        .trim(from: 0.0, to: 0.1)
                        .stroke(Color.white, lineWidth: 5)
                        .frame(width: 19, height: 19)
                        .rotationEffect(Angle(degrees: 270))
                )

                .overlay(
                    Circle()
                        .stroke(.gray, lineWidth: 0.1)
                        .frame(width: 16, height: 16)
                        .overlay(
                            Text("D")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.accentColor)
                        )
                )
        }
    }
}

struct DealerChip_Previews: PreviewProvider {
    static var previews: some View {
        DealerChip()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
