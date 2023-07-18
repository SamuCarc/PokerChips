//
//  SliderChip.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 11/6/23.
//

import SwiftUI

struct SliderChip: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color("AccentColor"))
                .frame(width: 36, height: 36)
                .shadow(radius: 1)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 1.5)
                        .shadow(color: .black, radius: 1.5, x: 0, y: 0)
                )
                .overlay(
                    Circle()
                        .trim(from: 0.0, to: 0.1)
                        .stroke(Color.white, lineWidth: 7)
                        .frame(width: 28, height: 28)
                        .rotationEffect(Angle(degrees: 90))
                )
                .overlay(
                    Circle()
                        .trim(from: 0.0, to: 0.1)
                        .stroke(Color.white, lineWidth: 7)
                        .frame(width: 28, height: 28)
                        .rotationEffect(Angle(degrees: 0))
                )
                .overlay(
                    Circle()
                        .trim(from: 0.0, to: 0.1)
                        .stroke(Color.white, lineWidth: 7)
                        .frame(width: 28, height: 28)
                        .rotationEffect(Angle(degrees: 180))
                )
                .overlay(
                    Circle()
                        .trim(from: 0.0, to: 0.1)
                        .stroke(Color.white, lineWidth: 7)
                        .frame(width: 28, height: 28)
                        .rotationEffect(Angle(degrees: 270))
                )

                .overlay(
                    Circle()
                        .stroke(.white, lineWidth: 1)
                        .frame(width: 22, height: 22)
                        .overlay(
                            Text("$")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        )
                )
        }
    }
}

struct SliderChip_Previews: PreviewProvider {
    static var previews: some View {
        SliderChip()
    }
}
