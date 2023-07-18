// TestCards.swift
// PokerChips
//
// Created by Samuel Carcasés on 10/5/23.
//

import SwiftUI
import PokerHandEvaluator

struct PlayerCard {
    let alias: String
    private var _cards: [Card]
    var totalBet: Int

    var cards: [Card] {
        get { return _cards }
        set { _cards = Array(newValue.prefix(2)) }
    }

    init(alias: String, cards: [Card], totalBet: Int) {
        self.alias = alias
        self._cards = Array(cards.prefix(2))
        self.totalBet = totalBet
    }
}

struct GameCards {
    private var _players: [PlayerCard]
    private var _communityCards: [Card]
    var pot: Int

    var players: [PlayerCard] {
        get { return _players }
        set { _players = newValue }
    }

    var communityCards: [Card] {
        get { return _communityCards }
        set { _communityCards = Array(newValue.prefix(5)) }
    }

    init(players: [PlayerCard], communityCards: [Card], pot: Int) {
        self._players = players
        self._communityCards = Array(communityCards.prefix(5))
        self.pot = pot
    }
}


struct TestCards: View {
    @Binding var game: GameCards

    var body: some View {
        VStack {
            Text("Ranking de manos")
                .foregroundColor(.accentColor)
                .font(.system(size: 14, weight: .bold, design: .rounded))

            //let handRankings = calculateHandRankings(game: game)
            let handRankings = calculateHandRankings(game: game)

            ForEach(handRankings, id: \.playerIndex) { ranking in
                let convertedCards = (ranking.playerCards + game.communityCards).convertToCardComponents()
                let usedCardIndices = ranking.usedCardIndices

                HStack {
                    VStack {
                        Text("\(ranking.alias): ")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                        Text("\(ranking.winnings.description)$")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                        Text("\(ranking.rank.description)º")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                        Text(ranking.bestHand.value.description)
                            .font(.system(size: 14, weight: .bold, design: .rounded))

                    }

                    ForEach(0..<convertedCards.count, id: \.self) { cardIndex in
                        let (cardNumber, cardType) = convertedCards[cardIndex]
                        let isHighlighted = usedCardIndices.contains(cardIndex)
                        CardComponent(number: cardNumber, type: cardType, isHidde: !isHighlighted)

                        if (cardIndex == 1) {
                            Divider()
                                .frame(height: 50)
                        }
                    }
                }
            }
        }
    }
}

struct TestCards_Previews: PreviewProvider {
    static var previews: some View {
        TestCards(game: .constant(GameCards(players: [
            PlayerCard(alias: "Naty", cards: [
                Card(.queen, .spades),
                Card(.jack, .clubs)
            ], totalBet: 600),
            PlayerCard(alias: "Samu", cards: [
                Card(.queen, .hearts),
                Card(.jack, .hearts)
            ], totalBet: 500),
            PlayerCard(alias: "Jose", cards: [
                Card(.queen, .spades),
                Card(.deuce, .clubs)
            ], totalBet: 610),


        ],
        communityCards: [
            Card(.ten, .hearts),
            Card(.nine, .spades),
            Card(.eight, .clubs),
            Card(.seven, .diamonds),
            Card(.six, .clubs)
        ], pot: 1120)))
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
