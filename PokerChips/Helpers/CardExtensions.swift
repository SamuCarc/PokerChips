// CardExtensions.swift
// PokerChips
//
// Created by Samuel Carcasés on 10/5/23.
//

import Foundation
import PokerHandEvaluator

// Extensión para Card
extension Card {
    func convertToCardComponent() -> (number: Numbers, type: cardTypes) {
        let convertedRank = self.rank.convertToNumbers()
        let convertedSuit = self.suit.convertToCardTypes()
        return (number: convertedRank, type: convertedSuit)
    }
}

// Extensión para Rank
extension Rank {
    func convertToNumbers() -> Numbers {
        switch self {
        case .deuce:
            return .two
        case .trey:
            return .three
        case .four:
            return .four
        case .five:
            return .five
        case .six:
            return .six
        case .seven:
            return .seven
        case .eight:
            return .eight
        case .nine:
            return .nine
        case .ten:
            return .ten
        case .jack:
            return .jack
        case .queen:
            return .queen
        case .king:
            return .kink
        case .ace:
            return .ace
        }
    }
}

// Extensión para Suit
extension Suit {
    func convertToCardTypes() -> cardTypes {
        switch self {
        case .clubs:
            return .clubs
        case .diamonds:
            return .diamonds
        case .hearts:
            return .hearts
        case .spades:
            return .spades
        }
    }
}

extension Array where Element == Card {
    func convertToCardComponents() -> [(Numbers, cardTypes)] {
        return self.map { card in
            let number = Numbers(rawValue: card.rank.rawValue + 2)
            let type: cardTypes
            switch card.suit {
            case .clubs:
                type = .clubs
            case .diamonds:
                type = .diamonds
            case .hearts:
                type = .hearts
            case .spades:
                type = .spades
            }
            return (number!, type)
        }
    }
}

func bestPokerHand(playerCards: [Card], communityCards: [Card]) -> (bestHand: Hand, usedCardIndices: [Int]) {
    let allCards = playerCards + communityCards
    let allCombinations = allCards.combinations(ofCount: 5)
    let hands = allCombinations.map { Hand($0) }
    
    let bestHandIndex = hands.indices.max(by: { hands[$0].value > hands[$1].value })!
    let bestHand = hands[bestHandIndex]
    let usedCards = allCombinations[bestHandIndex]
    
    let usedCardIndices = usedCards.map { card in
        allCards.firstIndex(where: { $0 == card })!
    }
    
    return (bestHand, usedCardIndices)
}

extension Collection {
    func combinations(ofCount count: Int) -> [[Element]] {
        guard count > 0 else { return [[]] }
        guard let first = self.first else { return [] }
        let subCombinations = Array(dropFirst()).combinations(ofCount: count - 1)
        return subCombinations.map { [first] + $0 } + Array(dropFirst()).combinations(ofCount: count)
    }
}

struct PlayerPot {
    let alias: String
    let playerIndex: Int
    let playerCards: [Card]
    let bestHand: Hand
    let usedCardIndices: [Int]
    var totalBet: Int
    var rank: Int
    var winnings: Int
}

func calculateHandRankings(game: GameCards) ->  [PlayerPot] {
    // Crear clasificaciones iniciales
    var handRankings = game.players.enumerated().map { index, player -> PlayerPot in
        let (bestHand, usedCardIndices) = bestPokerHand(playerCards: player.cards, communityCards: game.communityCards)
        return PlayerPot(alias: player.alias, playerIndex: index, playerCards: player.cards, bestHand: bestHand, usedCardIndices: usedCardIndices, totalBet: player.totalBet, rank: 0, winnings: 0)
    }

    // Ordenar las clasificaciones por el valor de la mano (menor primero) y luego por totalBet (menor a mayor)
    handRankings.sort(by: {
        if $0.bestHand.value == $1.bestHand.value {
            return $0.totalBet < $1.totalBet
        } else {
            return $0.bestHand.value < $1.bestHand.value
        }
    })

    // Agregar rango a los jugadores
    var currentRank = 1
    var currentHandValue = handRankings.first?.bestHand.value ?? 0

    for i in 0..<handRankings.count {
        if handRankings[i].bestHand.value != currentHandValue {
            currentRank += 1
            currentHandValue = handRankings[i].bestHand.value
        }
        handRankings[i].rank = currentRank
    }

    // Calcular las ganancias de cada jugador
    var remainingPot = game.pot
    var lastTotalBet = 0
    var currentWinningRank = 1
    for i in 0..<handRankings.count {
        // Comprobamos que el bote que quede sea mayor a cero
        if remainingPot <= 0 {
            break
        }
        // Actualizamos Rango y LastTotalBet
        if currentWinningRank != handRankings[i].rank {
            currentWinningRank += 1
        }

        let currentPlayerBet = handRankings[i].totalBet
        // Obtenemos nuestra apuesta multiplicada por cada jugador, en caso que un jugador haya apostado menos entonces nos quedamos solo con esa apuesta
        var currentPot = 0
        let betDifference = currentPlayerBet - lastTotalBet
        for j in 0..<handRankings.count {
            if (handRankings[j].rank >= currentWinningRank) {
                currentPot += min(max(handRankings[j].totalBet - lastTotalBet, 0), betDifference)
            }
        }

        lastTotalBet = currentPlayerBet

        // Divide el bote entre jugadores con el mismo rango y han hecho la apuesta mas alta o igual que ese bote
        let sameRankPlayers = handRankings.filter { $0.rank == handRankings[i].rank && $0.totalBet >= handRankings[i].totalBet }
        let winningsPerPlayer = currentPot / sameRankPlayers.count
        for j in 0..<handRankings.count {
            if handRankings[j].rank == currentWinningRank && handRankings[j].totalBet >= currentPlayerBet {
                handRankings[j].winnings += winningsPerPlayer
            }
        }

        remainingPot -= currentPot
    }

    return handRankings
}

func calculateWinnings(players: inout [PlayerInfo], firstPlacePlayers: inout Set<UUID>, secondPlacePlayers: inout Set<UUID>, thirdPlacePlayers: inout Set<UUID>) {
    // Crear un array de jugadores ordenados por posición y totalBet
    var orderedPlayers:[PlayerInfo] = players.sorted { player1, player2 in
        let player1Position = getPosition(for: player1)
        let player2Position = getPosition(for: player2)
        
        if player1Position == player2Position {
            return player1.totalBet < player2.totalBet
        } else {
            return player1Position < player2Position
        }
    }
    
    // Calcular las ganancias de cada jugador
    var remainingPot = orderedPlayers.reduce(0) { accumulator, player in
        accumulator + player.totalBet
    }
    var lastTotalBet = 0
    var currentWinningRank = 1
    
    for i in 0..<orderedPlayers.count {
        let currentPlayer:PlayerInfo = orderedPlayers[i]
        // Comprobamos que el bote que quede sea mayor a cero
        if remainingPot <= 0 {
            break
        }
        
        // Actualizamos el rango y lastTotalBet
        if currentWinningRank != getPosition(for: currentPlayer) {
            currentWinningRank = getPosition(for: currentPlayer)
        }
        
        let currentPlayerBet = currentPlayer.totalBet
        
        // Obtenemos nuestra apuesta multiplicada por cada jugador, en caso de que un jugador haya apostado menos, entonces nos quedamos solo con esa apuesta
        var currentPot = 0
        let betDifference = currentPlayerBet - lastTotalBet
        
        for j in 0..<orderedPlayers.count {
            if (getPosition(for: orderedPlayers[j])  >= currentWinningRank) {
                currentPot += min(max(orderedPlayers[j].totalBet - lastTotalBet, 0), betDifference)
            }
        }
        
        lastTotalBet = currentPlayerBet
        
        // Divide el bote entre jugadores con el mismo rango y han hecho la apuesta más alta o igual que ese bote
        let sameRankPlayers = orderedPlayers.filter { getPosition(for: $0) == currentWinningRank && $0.totalBet >= currentPlayerBet }
        let winningsPerPlayer = currentPot / sameRankPlayers.count
        
        for j in 0..<orderedPlayers.count {
            if getPosition(for: orderedPlayers[j]) == currentWinningRank && orderedPlayers[j].totalBet >= currentPlayerBet {
                orderedPlayers[j].win += winningsPerPlayer
            }
        }
        
        remainingPot -= currentPot
    }

    // Asignar las ganancias al array players en función del nuevo orden y rango
    for player in orderedPlayers {
        if let index = players.firstIndex(where: { $0.id == player.id }) {
            if getPosition(for: player) == 1 {
                players[index].status = .winner
            } else if player.win == 0 && players[index].totalAmount <= 0 {
                players[index].status = .leftGame
            } else if players[index].status != .leftGame {
                players[index].status = .none
            }
            players[index].win = player.win
            players[index].totalBet = 0
        }
    }
    
    // Limpiar Jugadores seleccionados
    firstPlacePlayers.removeAll()
    secondPlacePlayers.removeAll()
    thirdPlacePlayers.removeAll()
    
    
    func getPosition(for player: PlayerInfo) -> Int {
        if firstPlacePlayers.contains(player.id) {
            return 1
        } else if secondPlacePlayers.contains(player.id) {
            return 2
        } else if thirdPlacePlayers.contains(player.id) {
            return 3
        } else {
            return 4
        }
    }

}

