//
//  ConfigGame.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 16/6/23.
//

import SwiftUI

enum StepsConfig: Int {
    case colorTable = 1
    case initialStack = 2
    case blind = 3
    
    var name: String {
        switch self {
        case .colorTable:
            return "Color de la mesa"
        case .initialStack:
            return "Cantidad inicial"
        case .blind:
            return "Ajustes ciega"
        }
    }
    
    var hasNext: Bool {
        switch self {
        case .blind:
            return false
        default:
            return true
        }
    }
    
    var hasPrevious: Bool {
        switch self {
        case .colorTable:
            return false
        default:
            return true
        }
    }
    
    mutating func increment() {
        if hasNext {
            self = StepsConfig(rawValue: self.rawValue + 1)!
        }
    }
    
    mutating func decrement() {
        if hasPrevious {
            self = StepsConfig(rawValue: self.rawValue - 1)!
        }
    }
    
    var nextStep: StepsConfig? {
        return hasNext ? StepsConfig(rawValue: self.rawValue + 1) : nil
    }
    
    var previousStep: StepsConfig? {
        return hasPrevious ? StepsConfig(rawValue: self.rawValue - 1) : nil
    }
}

struct ConfigGame: View {
    @Binding var gameInfo: GameInfo
    @Binding var showGameSettings: Bool
    @Binding var startGame: Bool

    @State var showStep: StepsConfig = .colorTable
    var body: some View {
        VStack {
            ZStack {
                SelectColorTable(colorSelected: $gameInfo.colorTable)
                    .opacity(showStep == .colorTable ? 1 : 0)
                SelectInitStack(initialStack: $gameInfo.initialStack)
                    .opacity(showStep == .initialStack ? 1 : 0)
                SelectBlind(bigBlind: $gameInfo.bigBlind, raiseBlind: $gameInfo.raiseBlind,initialStack: $gameInfo.initialStack)
                    .opacity(showStep == .blind ? 1 : 0)
            }
            .frame(maxWidth: 620, maxHeight: 350)
            .overlay(
                Text("Configurar partida")
                    .foregroundColor(.white)
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                , alignment: .top
            )
            .overlay(
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showGameSettings = false
                    }
                } label: {
                    HStack (spacing: 0) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 25, weight: .bold, design: .rounded))
                            .foregroundColor(.accentColor)
                        Text("Jugadores")
                            .font(.system(size: 15, weight: .heavy, design: .rounded))
                    }
                    .padding(.horizontal, 40)
                }, alignment: .topLeading
                
            )
            .overlay(
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        startGame = true
                    }
                } label: {
                    ButtonStartGame()
                        .padding()
                }
                , alignment: .bottom
            )
            .overlay(
                Group {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showStep.decrement()
                        }
                    } label: {
                        HStack (spacing: 0) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 25, weight: .bold, design: .rounded))
                                .foregroundColor(.accentColor)
                            Text("\(showStep.previousStep?.name ?? "")")
                                .font(.system(size: 15, weight: .heavy, design: .rounded))
                        }
                        .padding(40)
                    }
                }
                    .opacity(showStep.hasPrevious ? 1 : 0)
                , alignment: .bottomLeading
            )
            .overlay(
                Group {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showStep.increment()
                        }
                    } label: {
                        HStack (spacing: 0) {
                            Text("\(showStep.nextStep?.name ?? "")")
                                .font(.system(size: 15, weight: .heavy, design: .rounded))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 25, weight: .bold, design: .rounded))
                                .foregroundColor(.accentColor)
                            
                        }
                        .padding(40)
                    }
                }
                .opacity(showStep.hasNext ? 1 : 0)
                , alignment: .bottomTrailing
            )
            .overlay(
                GeneralViewConfig(gameInfo: $gameInfo, showStep: $showStep)
                    .padding(.top, 40)
                ,alignment: .top
            )
        }
    }
}

struct ConfigGame_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Image("background")
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            ConfigGame(gameInfo: .constant(GameInfo(bigBlind: 200, raiseBlind: 2, initialStack: 20000, dealerIndex: 0, playingIndex: 0, stage: .preFlop, pot: 0, colorTable: .green)), showGameSettings: .constant(true), startGame: .constant(false))
        }
        .previewInterfaceOrientation(.landscapeLeft)
        .preferredColorScheme(.dark)
    }
}
