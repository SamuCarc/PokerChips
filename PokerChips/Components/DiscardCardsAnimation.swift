//
//  DiscardCartsAnimation.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 10/5/23.
//

import SwiftUI

struct DiscardCardsAnimation: View {
    @State private var card1Animation = false
    @State private var card2Animation = false
    @State private var hideCarts = true

    @Binding var showAnimation: Bool
    var amountPosition:AmountPosition

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.black)
                .opacity(0.8)
                .frame(width: 30, height: 45)
                .rotationEffect(.degrees(card1Animation ? 40 : 0))
                .offset(x: card1Animation ? 10 : 0, y: card1Animation ? -110 : 0)
                .opacity(!hideCarts ? 1 : 0)
                .rotationEffect(.degrees(amountPosition == .bottom ? 180 : amountPosition == .left ? 270 : amountPosition == .right ? 90 : 0))

            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.black)
                .opacity(0.8)
                .frame(width: 30, height: 45)
                .rotationEffect(.degrees(card2Animation ? 60 : 0))
                .offset(x: card2Animation ? 50 : 0, y: card2Animation ? -95 : 0)
                .opacity(!hideCarts ? 1 : 0)
                .rotationEffect(.degrees(amountPosition == .bottom ? 180 : amountPosition == .left ? 270 : amountPosition == .right ? 90 : 0))
        }
        .onAppear {
            startAnimation()
        }
        .onChange(of: showAnimation) { newValue in
            if newValue {
                startAnimation()
            }
        }
    }

    func startAnimation() {
        hideCarts = false
        card1Animation = false
        card2Animation = false

        withAnimation(.easeOut(duration: 0.40)) {
            card1Animation = true
        }
        withAnimation(.easeOut(duration: 0.50)) {
            card2Animation = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            withAnimation(.easeOut(duration: 0.3)) {
                hideCarts = true
            }
        }
    }

}

struct DiscardCartsAnimation_Previews: PreviewProvider {
    static var previews: some View {
        DiscardCardsAnimation(showAnimation: .constant(true), amountPosition: .top)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
