//
//  GameView.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 4/5/23.
//

import SwiftUI
import CoreData

enum Stage {
    case preFlop
    case flop
    case river
    case turn
}

struct GameView: View {
    //MARK: ANIMATIONS
    @State var showEndGameModal = false
    // AÑADIR NUMERO DE RONDAS
    // TIEMPO DE PARTIDA
    // APUESTA MÁXIMA
    // CIEGA
    // MEJOR MANO
    // CANTIDAD DE TIEMPO JUGADO POR CADA JUGADOR HASTA QUE TERMINÓ
    // CANTIDAD DE RONDAS JUGADAS POR CADA JUGADOR HASTA QUE TERMINÓ
    // RONDAS GANADAS X JUGADOR
    // RONDAS PERDIDAS X JUGADOR
    // MOSTRAR MODAL CON EL PRIMER PUESTO EN GRANDE, EL SEGUNDO UN POCO MAS EN NEGRITA OCULTO Y MAS PEQUEÑO y ASI...
    // DEBAJO MOSTRAR LAS ESTADISTICAS
    
    // AJUSTES
    // Reiniciar partida
    // Cambiar color de la mesa
    // Cambiar ciegas cada x tiempo/mantenerla (EN ONLINE MOSTRAR ALERTA A RESTO DE JUGADORES PARA QUE ACEPTEN)
    // Seleccionar próxima ciega (Si es con tiempo se cambia al acabar el tiempo, si no, en la siguiente ronda) (EN ONLINE MOSTRAR ALERTA A RESTO DE JUGADORES PARA QUE ACEPTEN)
    // (OFFLINE) ELIMINAR JUGADOR (AL ELIMINAR UN JUGADOR COMPROBAR SI SE PUEDE CONTINUAR LA PARTIDA) / (ONLINE/OFFLINE si no alcanza máximo de 8) AÑADIR JUGADOR
    // (ONLINE) Salir de la partida online / (OFFLINE) Salir de la partida y guardar estado (MAXIMO DE 10 partidas guardadas, si no, sobrescribir ultima bbdd local )
    //
    
    @State var showModalCards = false
    @State var showModalPlayers = true
    @State var showModalWin = false
    @State var buttonFold = false
    @State var buttonCheck = false
    @State var buttonCall = false
    @State var buttonRaise = false
    @State var buttonAllIn = false
    @State var animatePotChips = false
    @State var animateWin = false

    @Namespace var animation

    //MARK: PROPERTIES
    @State var valueToRaise:Int = 0
    @State var currentGameBet:Int = 0
    @State var minToRaise:Int = 0
    @State var maxToRaise:Int = 20000
    @State var callValue:Int = 0
    @State var dealerIndex:Int = 0
    @State var playingIndex:Int = 1
    @State var enableActions:Bool = false

    //MARK: INFO
    @Binding var gameInfo:GameInfo
    @Binding var playersInfo: [PlayerInfo]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                    ChipsAmount(totalAmount: $gameInfo.pot)
                        .padding()
                        .opacity(animatePotChips ? 1 : 0)
                        .zIndex(2)
                    StageTitle(amountPot: $gameInfo.pot, stage: $gameInfo.stage)

                ForEach(playersInfo.indices, id: \.self) { index in
                    if animateWin {
                        ChipsAmount(totalAmount: $playersInfo[index].win)
                            .matchedGeometryEffect(id: "animation_win_\($playersInfo[index].id)", in: animation)
                            .padding()
                            .zIndex(10)
                    }
                }


                HStack (spacing: 0) {
                    VStack (spacing: 0) {
                        Spacer()
                        if existOrderedPlayer(index: 0) {
                            getOrderedPlayer(index: 0)
                        }
                        if existOrderedPlayer(index: 9) {
                            getOrderedPlayer(index: 9)
                        }
                        Spacer()
                    }
                    .frame(width: geometry.size.width / 5)

                    Spacer()
                    VStack (spacing: 0) {
                        HStack (spacing: 0) {
                            Spacer()
                            if existOrderedPlayer(index: 1) {
                                getOrderedPlayer(index: 1)
                            }
                            if (existOrderedPlayer(index: 1) && existOrderedPlayer(index: 2)) || (existOrderedPlayer(index: 1) && existOrderedPlayer(index: 3)) {
                                Spacer()
                            }
                            if existOrderedPlayer(index: 2) {
                                getOrderedPlayer(index: 2)
                            }
                            if existOrderedPlayer(index: 2) && existOrderedPlayer(index: 3) {
                                Spacer()
                            }
                            if existOrderedPlayer(index: 3) {
                                getOrderedPlayer(index: 3)
                            }
                            Spacer()
                        }//:HSTACK
                        Spacer()
                        HStack (spacing: 0) {
                            Spacer()
                            if existOrderedPlayer(index: 8) {
                                getOrderedPlayer(index: 8)
                            }
                            if (existOrderedPlayer(index: 8) && existOrderedPlayer(index: 7)) || (existOrderedPlayer(index: 8) && existOrderedPlayer(index: 6)) {
                                Spacer()
                            }
                            if existOrderedPlayer(index: 7) {
                                getOrderedPlayer(index: 7)
                            }
                            if existOrderedPlayer(index: 7) && existOrderedPlayer(index: 6) {
                                Spacer()
                            }
                            if existOrderedPlayer(index: 6) {
                                getOrderedPlayer(index: 6)
                            }
                            Spacer()
                        }//:HSTACK
                    }//:VSTACK
                    .frame(width: geometry.size.width / 2)

                    Spacer()
                    VStack (spacing: 0) {
                        if existOrderedPlayer(index: 4) {
                            getOrderedPlayer(index: 4)
                        }
                        if existOrderedPlayer(index: 5) {
                            getOrderedPlayer(index: 5)
                        }
                    }
                    .frame(width: geometry.size.width / 5)
                }//:HSTACK
            }//:ZSTACK
            .overlay(
                Button {
                    showModalCards.toggle()
                } label: {
                    ButtonPokerHands()
                }
                .sheet(isPresented: $showModalCards) {
                    PokerHandsView(colorTable: $gameInfo.colorTable)
                }
                .padding(), alignment: .topTrailing
            )
            .overlay(
                Button {
                    withAnimation {
                        dealerIndex = nextIndex(index: dealerIndex)
                        switch gameInfo.colorTable {
                        case .white:
                            gameInfo.colorTable = .black
                        case .black:
                            gameInfo.colorTable = .blue
                        case .blue:
                            gameInfo.colorTable = .red
                        case .red:
                            gameInfo.colorTable = .green
                        case .green:
                            gameInfo.colorTable = .pink
                        case .pink:
                            gameInfo.colorTable = .white
                        }
                    }
                } label: {
                    SettingsIcon()
                }
                .padding(), alignment: .topLeading
            )
            // BOTONES DE ACCIÓN
            .overlay(
                VStack (alignment: .trailing) {
                    if (buttonRaise || (buttonAllIn && maxToRaise > minToRaise)) {
                        SliderRaise(raiseValue: $valueToRaise, minValue: $minToRaise, maxValue: $maxToRaise)
                            .padding(10)
                    }

                    HStack (spacing: 15) {
                        if buttonCheck {
                            Button {
                                setPlayerAction(bet: 0, status: .check)
                            } label: {
                                ButtonCheck()
                                    .opacity(buttonCheck ? 1 : 0)
                            }
                        }

                        if buttonCall {
                            Button {
                                setPlayerAction(bet: callValue, status: .call)
                            } label: {
                                ButtonCall()
                            }
                            .opacity(buttonCall ? 1 : 0)
                            .disabled(!buttonCall)
                        }
                        if buttonRaise {
                            Button {
                                setPlayerAction(bet: valueToRaise, status: .raise)
                            } label: {
                                ButtonRaise(raise: $valueToRaise)
                                    .opacity(buttonRaise ? 1 : 0)
                            }
                        }
                        if buttonAllIn {
                            Button {
                                setPlayerAction(bet: maxToRaise, status: .allIn)
                            } label: {
                                ButtonAllIn(raise: $maxToRaise)
                                    .opacity(buttonAllIn ? 1 : 0)
                            }
                        }
                    }
                }, alignment: .bottomTrailing
            )
            .overlay(
                    Button {
                        setPlayerAction(bet: 0, status: .fold)
                    } label: {
                        if buttonFold {
                            ButtonFold()
                                .opacity(buttonFold ? 1 : 0)
                        }
                    }, alignment: .bottomLeading
            )

            .overlay(
                ZStack {                    
                    ShowPlayers(playersInfo: playersInfo, initialStack: gameInfo.initialStack, showModalPlayers: $showModalPlayers)
                }
            )
            .overlay(
                ModalWin(playersInfo: $playersInfo, gameInfo: $gameInfo, showModalWin: $showModalWin)
                        .opacity(showModalWin ? 1 : 0)
            )
            .onAppear {
                // Update Position
                var updatedPlayersInfo = playersInfo
                for index in 0..<10 {
                    let orderedIndex = orderTableByPlayersNum(index: index)
                    let existInIndex = existOrderedPlayer(index: index)
                    if existInIndex {
                        if index == 0 || index == 9 {
                            updatedPlayersInfo[orderedIndex].amountPosition = .right
                        } else if index == 1 || index == 2 || index == 3 {
                            updatedPlayersInfo[orderedIndex].amountPosition = .bottom
                        } else if index == 4 || index == 5 {
                            updatedPlayersInfo[orderedIndex].amountPosition = .left
                        } else if index == 6 || index == 7 || index == 8 {
                            updatedPlayersInfo[orderedIndex].amountPosition = .top
                        }
                    }
                }
                playersInfo = updatedPlayersInfo

                updateInitialStack()
                // SET PLAYER SETTINGS
                setPlayerSettings()

                let startGameDelay:Double = playersInfo.count > 8 ? 9 : playersInfo.count > 4 ? 6 : 3
                DispatchQueue.main.asyncAfter(deadline: .now() + startGameDelay) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showModalPlayers = false
                    }
                }

            }
            .onChange(of: valueToRaise) { newValueRaise in
                if buttonAllIn || buttonRaise {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if newValueRaise == maxToRaise {
                            buttonAllIn = true
                            buttonRaise = false
                        } else {
                            buttonRaise = true
                            buttonAllIn = false
                        }
                    }
                }
            }
            .onChange(of: showModalPlayers) { newModalPlayers in
                if !newModalPlayers {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showButtons()
                        checkPlayer()
                    }
                }
            }
            .onChange(of: showModalWin) { newWin in
                // Update Earnings
                if !newWin {
                    startAnimationWin()
                }
            }
            .background(Background(colorTable: $gameInfo.colorTable))
        }//:GEOMETRY
    }
}

struct GameView_Previews: PreviewProvider {
    let gradient = Gradient(colors: [.red, .yellow])
    static var playersInfo: [PlayerInfo] = [
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_9", alias: "Samuel", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_9", alias: "Samuel", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_9", alias: "Samuel", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_9", alias: "Samuel", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_9", alias: "Samuel", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_9", alias: "Samuel", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_9", alias: "Samuel", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_9", alias: "Samuel", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_9", alias: "Samuel", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
    ]

    static var gameInfo: GameInfo = GameInfo(bigBlind: 200, raiseBlind: 2, initialStack: 20000, dealerIndex: 0, playingIndex: 0, stage: .preFlop, pot: 0, colorTable: .green)
    static var previews: some View {
        GameView(gameInfo: .constant(gameInfo), playersInfo: .constant(playersInfo))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
