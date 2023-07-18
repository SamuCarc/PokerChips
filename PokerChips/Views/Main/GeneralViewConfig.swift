//
//  GeneralViewConfig.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 20/6/23.
//

import SwiftUI
import AnimatedNumber

struct GeneralViewConfig: View {
    @Binding var gameInfo: GameInfo
    @Binding var showStep: StepsConfig
    @State private var displayedInitialStack: Double = 0
    @State private var displayedBlind: Double = 0
    @State private var displayedRaiseBlind: Double = 0

    let formatter = NumberFormatter()
    let formatterMin = NumberFormatter()
    init(gameInfo: Binding<GameInfo>, showStep: Binding<StepsConfig>) {
        self._gameInfo = gameInfo
        self._showStep = showStep
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        formatter.positiveSuffix = " €"
        
        formatterMin.numberStyle = .decimal
        formatterMin.locale = Locale.current
        formatterMin.maximumFractionDigits = 0
        formatterMin.positiveSuffix = "'"
    }

    var body: some View {
        HStack (alignment: .top, spacing: 10) {
            // Color de la mesa
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showStep = .colorTable
                }
            } label: {
                VStack (spacing: 5) {
                    Text("Mesa")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 13, weight: showStep == .colorTable ? .heavy : .regular, design: .rounded))
                        .frame(width: 50, height: 13)

                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(RadialGradient(gradient: Gradient(colors: [.black, Color("\(gameInfo.colorTable.rawValue)Dark")]), center: .center, startRadius: 150, endRadius: 0))
                            .frame(width: 25, height: 25)
                            .zIndex(2)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.accentColor.opacity(1), lineWidth: showStep == .colorTable ? 2 : 1)
                            .frame(width: 25, height: 25)
                            .zIndex(2)
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.accentColor.opacity(0.4), lineWidth: showStep == .colorTable ? 3 : 2)
                            .frame(width: 26, height: 26)
                            .zIndex(2)
                    }
                }
                .scaleEffect(showStep == .colorTable ? 1.1 : 1)
            }
            Divider()
                .frame(width: 2, height: 40)
                .overlay(Color.accentColor.opacity(0.5))
            // Cantidad inicial
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showStep = .initialStack
                }
            } label: {
                VStack {
                    Text("Cantidad inicial")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 13, weight: showStep == .initialStack ? .heavy : .regular, design: .rounded))
                        .frame(width: 110, height: 13)
                    
                    AnimatedNumber($displayedInitialStack, duration: 0.5, formatter: formatter)
                        .frame(width: 75)
                        .font(.system(size: 15, weight: showStep == .initialStack ? .heavy : .bold , design: .rounded))
                        .foregroundColor(.white)
                }
                .scaleEffect(showStep == .initialStack ? 1.1 : 1)
            }
            Divider()
                .frame(width: 2, height: 40)
                .overlay(Color.accentColor.opacity(0.5))
            // Ciega
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showStep = .blind
                }
            } label: {
                VStack {
                    Text("Ciega")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 13, weight: showStep == .blind ? .heavy : .regular, design: .rounded))
                        .frame(width: 100, height: 13)
                    
                    HStack (spacing: 0) {
                        AnimatedNumber($displayedBlind, duration: 0.5, formatter: formatter)
                            .font(.system(size: 15, weight: showStep == .blind ? .heavy : .bold , design: .rounded))
                            .foregroundColor(.white)
                            .padding(.trailing, 10)
                        Image(systemName: "arrow.up")
                            .font(.system(size: 15, weight: showStep == .blind ? .heavy : .bold, design: .rounded))
                            .foregroundColor(.accentColor)
                        AnimatedNumber($displayedRaiseBlind, duration: 0.5, formatter: formatterMin)
                            .font(.system(size: 15, weight: showStep == .blind ? .heavy : .bold , design: .rounded))
                            .foregroundColor(.white)

                    }
                    .frame(width: 120)
                }
                .scaleEffect(showStep == .blind ? 1.1 : 1)
            }

        }
        .padding(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.accentColor.opacity(1), lineWidth: 1)
        )
        .onAppear {
            displayedInitialStack = Double(gameInfo.initialStack)
            displayedBlind = Double(gameInfo.bigBlind)
            displayedRaiseBlind = Double(gameInfo.raiseBlind)
        }
        .onChange(of: gameInfo.initialStack) { newValue in
            displayedInitialStack = Double(newValue)
        }
        .onChange(of: gameInfo.bigBlind) { newValueBlind in
            displayedBlind = Double(newValueBlind)
        }
        .onChange(of: gameInfo.raiseBlind) { newValueRaiseBlind in
            displayedRaiseBlind = Double(newValueRaiseBlind)
        }
    }
}

struct GeneralViewConfig_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Image("background")
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            GeneralViewConfig(gameInfo: .constant(GameInfo(bigBlind: 200, raiseBlind: 15, initialStack: 20000, dealerIndex: 0, playingIndex: 0, stage: .preFlop, pot: 0, colorTable: .green)), showStep: .constant(.blind))
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
