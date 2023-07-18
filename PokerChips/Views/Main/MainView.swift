//
//  MainView.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 15/6/23.
//

import SwiftUI

struct PlayerInfo:Hashable, Identifiable {
    var id = UUID()
    var totalAmount: Int
    var status: PlayerAction
    var avatar: String
    var alias: String
    var amountPosition: AmountPosition
    var bet:Int
    var totalBet:Int
    var win:Int
}

struct GameInfo {
    var smallBlind:Int {
        return self.bigBlind / 2
    }
    var bigBlind:Int
    var raiseBlind:Int
    var initialStack:Int
    var dealerIndex:Int
    var playingIndex:Int
    var stage:Stage
    var pot:Int
    var colorTable: ColorTable
}
struct MainView: View {
    @State var startGame:Bool = false
    @State var gameInfo:GameInfo = GameInfo(bigBlind: 200, raiseBlind: 15, initialStack: 20000, dealerIndex: 0, playingIndex: 0, stage: .preFlop, pot: 0, colorTable: .green)
    @State var playersInfo: [PlayerInfo] = []
    @State var showGameSettings: Bool = false
    var body: some View {
        Group {
            if startGame {
                GameView(gameInfo: $gameInfo, playersInfo: $playersInfo)
            } else {
                ZStack {
                    if !showGameSettings {
                        AddPlayers(playersInfo: $playersInfo, showGameSettings: $showGameSettings)
                            .opacity(!showGameSettings ? 1 : 0)
                    } else {
                        ConfigGame(gameInfo: $gameInfo, showGameSettings: $showGameSettings, startGame: $startGame)
                            .opacity(showGameSettings ? 1 : 0)
                    }
                }
                .background(
                    Image("background")
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                )
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
