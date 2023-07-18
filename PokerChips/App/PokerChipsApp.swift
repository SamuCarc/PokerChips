//
//  PokerChipsApp.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 4/5/23.
//

import SwiftUI
import PokerHandEvaluator

@main
struct PokerChipsApp: App {

    let persistenceController = PersistenceController.shared
    @State var selectedAvatarIndex: Int = 3
    @State var game:GameCards = GameCards(players: [
        PlayerCard(alias: "Naty", cards: [
            Card(.queen, .spades),
            Card(.jack, .clubs)
        ], totalBet: 600),
        PlayerCard(alias: "Samu", cards: [
            Card(.queen, .hearts),
            Card(.jack, .hearts)
        ], totalBet: 500),
        PlayerCard(alias: "Daniel", cards: [
            Card(.queen, .spades),
            Card(.four, .clubs)
        ], totalBet: 610),
    ],
    communityCards: [
        Card(.ten, .hearts),
        Card(.nine, .spades),
        Card(.eight, .clubs),
        Card(.seven, .diamonds),
        Card(.six, .clubs)
    ], pot: 1710)
    
    var body: some Scene {
        WindowGroup {
            /*TestCards(game: $game)*/
            //GameView()
            //CreatePlayer()
            MainView()
        }
    }
}
