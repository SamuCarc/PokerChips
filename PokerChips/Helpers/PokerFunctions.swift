//
//  PokerFunctions.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 5/5/23.
//

import Foundation
import SwiftUI

extension GameView {
    //MARK: FUNCIONES PARA ORDENAR LOS JUGADORES EN LA MESA EN FUNCION DE LA CANTIDAD
    func orderTableByPlayersNum (index:Int) -> Int {
        if (index == 0) { return index }
        let playerNum = playersInfo.count
        var num = -1
        switch playerNum {
        case 2:
            if (index == 5) {
                num = 1
            }
            return num
        case 3, 4, 5:
            if (index == 2) {
                num = 1
            } else if (index == 5) {
                num = 2
            } else if (index == 6) {
                num = 3
            } else if (index == 8) {
                num = 4
            }
            return num
        case 6, 7, 8:
            if (index == 1) {
                num = 1
            } else if (index == 3) {
                num = 2
            } else if (index == 4) {
                num = 3
            } else if (index == 5) {
                num = 4
            } else if (index == 6) {
                num = 5
            } else if (index == 8) {
                num = 6
            } else if (index == 9) {
                num = 7
            }
            return num
        case 9, 10:
            return index
        default:
            return num
        }
    }

    func getOrderedPlayer(index: Int) -> some View {
        let orderedIndex = orderTableByPlayersNum(index: index)
        return Player(playerInfo: $playersInfo[orderedIndex], isDealer: .constant(dealerIndex == orderedIndex), isPlaying: .constant(playingIndex == orderedIndex), animation: animation)
    }

    func existOrderedPlayer (index:Int) -> Bool {
        let orderedIndex = orderTableByPlayersNum(index: index)
        return orderedIndex < playersInfo.count && orderedIndex >= 0
    }
    
    //MARK: ACCIONES DEL JUGADOR
    func setPlayerAction(bet:Int, status: PlayerAction) {
        if !enableActions && status != .smallBlind && status != .bigBlind {
            return
        }
        hideButtons()
        betPlayer(bet: maxToRaise <= bet ? maxToRaise : bet)
        setPlayerStatus(status: maxToRaise <= bet ? .allIn : status)
        nextPlayer()
    }
    
    //MARK: ANIMACION DE GANADOR
    func startAnimationWin() {
        // Hide buttons
        hideButtons()
        // None is playing
        playingIndex = -1
        // RESET POT
        gameInfo.pot = 0
        withAnimation(.easeInOut(duration: 0.3)) {
            animateWin = true
        }
        withAnimation(.easeInOut(duration: 0.3).delay(3)) {
            animateWin = false
        }

        // Distribute winnings in total amount.
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            for index in playersInfo.indices {
                playersInfo[index].totalAmount += playersInfo[index].win
                playersInfo[index].win = 0
            }
        }
        
        // Start next Round.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            startNewRound()
        }
    }

    //MARK: ANIMACION DE UNICO GANADOR
    func startAnimationWinUniquePlayer() {
        // Obtenemos el POT
        updatePotAndResetBets()
        // ASIGNAMOS LAS GANANCIAS AL JUGADOR
        for (index, player) in playersInfo.enumerated() {
            // GANADOR
            if player.status != .fold && player.status != .leftGame {
                playersInfo[index].status = .winner
                playersInfo[index].win += gameInfo.pot
            }
            else if player.win == 0 && player.totalAmount == 0 {
                playersInfo[index].status = .leftGame
            } else if player.status != .leftGame {
                playersInfo[index].status = .none
            }
            playersInfo[index].totalBet = 0
        }
        startAnimationWin()
    }

    //MARK: ANIMACION DE ALL IN
    func startAnimationWinAllIn() {
        // Update Pot and Bets
        updatePotAndResetBets()
        // Animate Pot
        withAnimation(.easeInOut(duration: 0.3)) {
            animatePotChips = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.5)) {
                animatePotChips = false
            }
        }

        if gameInfo.stage == .preFlop {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeOut(duration: 0.5)) {
                    gameInfo.stage = .flop
                }
            }
        }
        if gameInfo.stage == .flop || gameInfo.stage == .preFlop {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeOut(duration: 0.5)) {
                    gameInfo.stage = .turn
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation(.easeOut(duration: 0.5)) {
                gameInfo.stage = .river
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            showModalWin = true
        }
    }
    
    //MARK: COMPROBACIONES DEL JUGADOR, CADA VEZ QUE HAY UN CAMBIO EN PLAYERINDEX
    func checkPlayer() {
        // SET PLAYER SETTINGS
        setPlayerSettings()

        // UNIQUE PLAYER WIN
        if (isUniquePlayerActive()) {
            startAnimationWinUniquePlayer()
        }
        // ALL PLAYERS ALL IN
        else if (isAllIn()) {
            startAnimationWinAllIn()
        }
        // Is SmallBlind
        else if (nextIndex(index: dealerIndex) == playingIndex && (playersInfo[playingIndex].status == .none || playersInfo[playingIndex].status == .winner) && gameInfo.stage == .preFlop) {
            let bet = gameInfo.smallBlind
            setPlayerAction(bet: bet, status: .smallBlind)
        }
        // Is BigBlind
        else if (nextIndex(index: dealerIndex) == prevIndex(index: playingIndex) && (playersInfo[playingIndex].status == .none || playersInfo[playingIndex].status == .winner) && gameInfo.stage == .preFlop) {
            let bet = gameInfo.bigBlind
            setPlayerAction(bet: bet, status: .bigBlind)
        }
        // Fold, All In, Left Game
        else if (playersInfo[playingIndex].status == .allIn || playersInfo[playingIndex].status == .fold  || playersInfo[playingIndex].status == .leftGame) {
            nextPlayer()
        }
        // Next Stage
        else if shouldTransitionToNextStage() {
            nextStage()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // Show Action Buttons
                showButtons()
            }

        }
    }

    //MARK: TODOS ALLIN
    func isAllIn() -> Bool {
        // ARRAY CON JUGADORES QUE PUEDEN SEGUIR APOSTANDO
        let activeBetPlayers = playersInfo.filter { player in
            player.status != .fold && player.status != .leftGame  && player.status != .allIn
        }
        return (activeBetPlayers.count == 0) || (activeBetPlayers.count == 1 && playersInfo[playingIndex].bet >= currentGameBet)
    }

    //MARK: ES EL ÚNICO JUGADOR ACTIVO
    func isUniquePlayerActive() -> Bool {
        // ARRAY CON JUGADORES ACTIVOS
        let activePlayers = playersInfo.filter { player in
            player.status != .fold && player.status != .leftGame
        }
        return activePlayers.count <= 1
    }

    //MARK: PROXIMO INDEX DE JUGADOR MENOS LOS QUE HAYAN DEJADO LA PARTIDA
    func nextIndex(index:Int) -> Int {
        var nextI = (playersInfo.count - 1 <= index) ? 0 : index + 1
        if (playersInfo[nextI].status == .leftGame) {
            nextI = nextIndex(index: nextI)
        }
        return nextI
    }
    
    //MARK: ANTERIOR INDEX DE JUGADOR MENOS LOS QUE HAYAN DEJADO LA PARTIDA
    func prevIndex(index:Int) -> Int {
        var prevI = (index <= 0) ? playersInfo.count - 1 : index - 1
        if (playersInfo[prevI].status == .leftGame) {
            prevI = prevIndex(index: prevI)
        }
        return prevI
    }
    
    //MARK: APOSTAR
    func betPlayer(bet:Int) {
        playersInfo[playingIndex].totalAmount -= bet
        playersInfo[playingIndex].bet += bet
        playersInfo[playingIndex].totalBet += bet
        
        if playersInfo[playingIndex].bet > currentGameBet {
            currentGameBet = playersInfo[playingIndex].bet
        }
    }
    
    //MARK: CAMBIAR AL SIGUIENTE JUGADOR
    func nextPlayer() {
        playingIndex = nextIndex(index: playingIndex)
        // CHECK PLAYER
        checkPlayer()
    }
    
    //MARK: CAMBIAR EL JUGADOR CUANDO CAMBIA DE ETAPA
    func nextPlayerInNewStage() {
        playingIndex = nextIndex(index: dealerIndex)
        // CHECK PLAYER
        checkPlayer()
    }

    //MARK: NUEVA RONDA O FINALIZAR PARTIDA
    func startNewRound() {
        // CHECK IF A PLAYER WIN
        if (isFinished()) {
            showEndGameModal = true
        } else {
            // GO TO FIRST STAGE PREFLOP
            gameInfo.stage = .preFlop
            // CHANGE THE DEALER
            withAnimation(.easeInOut(duration: 0.3)) {
                dealerIndex = nextIndex(index: dealerIndex)
            }
            // PLAYER SETTINGS AND ACTIONS
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                playingIndex = nextIndex(index: dealerIndex)
                // CHECK PLAYER
                checkPlayer()
            }
        }
    }
    
    //MARK: ONLY ONE LEFT STANDING
    func isFinished() -> Bool {
        // ARRAY CON JUGADORES QUE SIGUEN JUGANDO
        let activePlayers = playersInfo.filter { player in
           player.status != .leftGame
        }
        return activePlayers.count <= 1
    }

    //MARK: COMPROBAR SI DEBERIAMOS CAMBIAR DE ETAPA
    func shouldTransitionToNextStage() -> Bool {
        let allPlayersMatchedMaxBet = playersInfo.allSatisfy { player in
            switch player.status {
            case .none, .raise, .smallBlind, .bigBlind:
                return false
            case .allIn, .fold, .leftGame:
                return player.bet <= currentGameBet
            default:
                return player.bet == currentGameBet
            }
        }

        return allPlayersMatchedMaxBet
    }
    
    //MARK: OBTENER POSIBLES ACCIONES DEL USUARIO
    func setPlayerSettings() {
        let currentPlayerBet:Int = playersInfo[playingIndex].bet
        callValue = currentGameBet - currentPlayerBet
        minToRaise = 0
        maxToRaise = playersInfo[playingIndex].totalAmount
        valueToRaise = minToRaise
    }
    
    //MARK: PROXIMA ETAPA
    func nextStage() {
        // Update Pot and Bets
        updatePotAndResetBets()
        // Animate Pot
        withAnimation(.easeInOut(duration: 0.3)) {
            animatePotChips = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // Show Action Buttons
            showButtons()
            withAnimation(.easeInOut(duration: 0.5)) {
                animatePotChips = false
            }
        }

        // Update all players status
        playersInfo = playersInfo.map { player in
            var updatedPlayer = player
            if updatedPlayer.status != .allIn && updatedPlayer.status != .leftGame && updatedPlayer.status != .fold {
                updatedPlayer.status = .none
            }
            return updatedPlayer
        }

        // Change Stage
        switch gameInfo.stage {
        case .preFlop:
            gameInfo.stage = .flop
        case .flop:
            gameInfo.stage = .turn
        case .turn:
            gameInfo.stage = .river
        case .river:
            showModalWin = true
        }
        
        if gameInfo.stage != .river {
            // Current Player
            nextPlayerInNewStage()
        }
    }

    //MARK: BOTONES
    func hideButtons() {
        enableActions = false
        buttonCall = false
        buttonFold = false
        buttonCheck = false
        buttonRaise = false
        buttonAllIn = false
    }
    
    func showButtons() {
        enableActions = true
        withAnimation(.easeInOut(duration: 0.3)) {
            buttonFold = true
            if (callValue == 0) {
                buttonCheck = true
            } else if (callValue > 0 && callValue < maxToRaise) {
                buttonCall = true
            }
            
            if (maxToRaise > minToRaise && valueToRaise < maxToRaise) {
                buttonRaise = true
            } else {
                buttonAllIn = true
            }
        }
    }

    //MARK: LOS JUGADORES EMPIEZAN CON EL DINERO CONFIGURADO EN LA PARTIDA
    func updateInitialStack () {
        playersInfo = playersInfo.map { player in
            var updatedPlayer = player
            updatedPlayer.totalAmount = gameInfo.initialStack
            return updatedPlayer
        }
    }

    //MARK: OBTENER POT Y DEJAR BET A CERO
    func updatePotAndResetBets() {
        // Suma las apuestas de todos los jugadores al pot
        let totalBet = playersInfo.reduce(0) { accumulator, player in
            accumulator + player.bet
        }
        gameInfo.pot += totalBet
        currentGameBet = 0
        // Resetea las apuestas de todos los jugadores a cero
        playersInfo = playersInfo.map { player in
            var updatedPlayer = player
            updatedPlayer.bet = 0
            return updatedPlayer
        }
    }
    
    //MARK: ESTADO DEL JUGADOR
    func setPlayerStatus(status: PlayerAction) {
        playersInfo[playingIndex].status = status
    }
}

func formatCurrency(amount: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.locale = Locale.current
    formatter.positiveSuffix = " €"
    formatter.maximumFractionDigits = 0
    
    return formatter.string(from: NSNumber(value: amount)) ?? "\(amount) €"
}
