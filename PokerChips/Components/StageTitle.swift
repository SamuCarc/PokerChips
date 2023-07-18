//
//  StageTitle.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 5/5/23.
//

import SwiftUI
import AnimatedNumber

struct StageTitle: View {
    @Binding var amountPot:Int
    @Binding var stage:Stage
    @State private var displayedAmount: Double = 0
    @State private var animatePreFlop: Bool = false
    @State private var animateFlop: Bool = false
    @State private var animateTurn: Bool = false
    @State private var animateRiver: Bool = false

    let formatter = NumberFormatter()

    init(amountPot: Binding<Int>, stage: Binding<Stage>) {
        self._amountPot = amountPot
        self._stage = stage
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        formatter.positiveSuffix = " €"
    }
    
    var body: some View {
        ZStack {
            if displayedAmount > 0 {
                AnimatedNumber($displayedAmount, duration: 0.5, formatter: formatter)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                    .background(Color.accentColor.opacity(0.7))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .offset(y: 55)
            }

            if animatePreFlop {
                Text("Pre-flop")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.accentColor)
                    .frame(width: 120, height: 50)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 70)
                            .stroke(Color.black.opacity(0.8), lineWidth: 4)
                            .frame(width: 130, height: 60)
                    )
                    .opacity(animatePreFlop ? 1 : 0)

            } else {
                HStack (spacing: 10) {
                    VStack (spacing: 5) {
                        Text("Flop")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(.accentColor)
                            .cornerRadius(20)

                        HStack (spacing: 3) {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(.black)
                                .opacity(0.8)
                                .frame(width: 75, height: 100)
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(.black)
                                .opacity(0.8)
                                .frame(width: 75, height: 100)
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(.black)
                                .opacity(0.8)
                                .frame(width: 75, height: 100)
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black.opacity(0.2), lineWidth: 2)
                                .frame(width: 235, height: 105)
                        }
                    }
                    .offset(y: animateFlop ? 0 : -25)
                    .opacity(animateFlop ? 1 : 0)
                    
                    if stage == .turn || stage == .river {
                        VStack (spacing: 5) {
                            Text("Turn")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(.accentColor)
                                .cornerRadius(20)
                            VStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(.black)
                                        .opacity(0.8)
                                        .frame(width: 75, height: 100)
                                }
                                .overlay {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black.opacity(0.2), lineWidth: 2)
                                        .frame(width: 80, height: 105)
                            }

                        }
                        .offset(y: animateTurn ? 0 : -25)
                        .opacity(animateTurn ? 1 : 0)
                    }
                    if stage == .river {
                        VStack (spacing: 5) {
                            Text("River")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(.accentColor)
                                .cornerRadius(20)
                            VStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(.black)
                                        .opacity(0.8)
                                        .frame(width: 75, height: 100)
                                }
                                .overlay {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black.opacity(0.2), lineWidth: 2)
                                        .frame(width: 80, height: 105)
                            }

                        }
                        .offset(y: animateRiver ? 0 : -25)
                        .opacity(animateRiver ? 1 : 0)
                    }
                }
                .offset(y:-18)
            }
        }
        .onAppear {
            displayedAmount = Double(amountPot)
            if stage == .preFlop {
                withAnimation(.easeOut(duration: 0.5)) {
                    animatePreFlop = true
                }
            }

            if stage == .flop {
                withAnimation(.easeOut(duration: 0.5)) {
                    animateFlop = true
                }
            }
            if stage == .turn {
                withAnimation(.easeOut(duration: 0.5)) {
                    animateTurn = true
                }

            }
            if stage == .river {
                withAnimation(.easeOut(duration: 0.5)) {
                    animateRiver = true
                }
            }
        }
        .onChange(of: amountPot) { newValue in
            displayedAmount = Double(newValue)
        }
        .onChange(of: stage) { newStage in
            animatePreFlop = false
            if newStage == .preFlop {
                withAnimation(.easeOut(duration: 0.5)) {
                    animatePreFlop = true
                }
            }

            if newStage == .flop {
                animateFlop = false
                withAnimation(.easeOut(duration: 0.5)) {
                    animateFlop = true
                }
            }
            if newStage == .turn {
                animateTurn = false
                withAnimation(.easeOut(duration: 0.5)) {
                    animateTurn = true
                }

            }
            if newStage == .river {
                animateRiver = false
                withAnimation(.easeOut(duration: 0.5)) {
                    animateRiver = true
                }
            }
        }
    }
}

struct StageTitle_Previews: PreviewProvider {
    static var previews: some View {
        StageTitle(amountPot: .constant(1120), stage: .constant(.flop))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
