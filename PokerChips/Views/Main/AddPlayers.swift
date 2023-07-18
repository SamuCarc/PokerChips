//
//  AddPlayers.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 15/6/23.
//

import SwiftUI

struct AddPlayers: View {
    @Binding var playersInfo: [PlayerInfo]
    @Binding var showGameSettings: Bool
    @State var showModalCreate:Bool = false
    @State var deleteMode:Bool = false
    @State var showToast: Bool = false
    let maxPlayers: Int = 10
    var body: some View {
        ZStack {
            if showModalCreate {
                CreatePlayer(showModalCreate: $showModalCreate, playersInfo: $playersInfo)
                    .zIndex(1)
            }
            
            VStack (alignment: .center, spacing: 0) {
                
                let columns = [
                    GridItem(.adaptive(minimum: 170)),
                ]
                
                if playersInfo.count > 0 {
                    ScrollView  {
                        LazyVGrid(columns: columns, alignment: .center, spacing: 0) {
                            ForEach(playersInfo, id: \.self) { player in
                                Button {
                                    if deleteMode {
                                        withAnimation(.easeOut) {
                                            playersInfo.removeAll(where: { $0 == player })
                                            deleteMode.toggle()
                                        }
                                    }
                                } label: {
                                    PlayerAddRow(playerNumber: playersInfo.firstIndex(of: player)! + 1, player: player, isDeleteMode: $deleteMode)
                                }
                                .transition(.scale)
                            }
                        }
                        .padding(.top, 35)
                        .padding(.bottom, 80)
                        .padding(.horizontal, 30)
                    }
                    .frame(maxWidth: 620, maxHeight: 270)
                    .mask {
                        LinearGradient(colors: [.clear, .black, .black, .black, .black, .clear], startPoint: .top, endPoint: .bottom)
                    }
                } else {
                    Spacer()
                    Group {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 60, weight: .regular, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.bottom, 10)

                        Text("Añade jugadores a la partida")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .padding(.bottom, 30)
                    }
                    .opacity(0.5)
                    Spacer()
                    
                }
                Spacer()
            }
            .padding()
            .frame(maxWidth: 620, maxHeight: 350)
            .opacity(!showModalCreate ? 1 : 0)
            .overlay(
                Text("Jugadores")
                    .foregroundColor(.white)
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                , alignment: .top
            )
            .overlay(
                Group {
                    if playersInfo.count < maxPlayers && !deleteMode {
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showModalCreate.toggle()
                            }
                        } label: {
                            AddButton()
                                .padding()
                        }
                    }
                }
                , alignment: .bottom
            )
            .overlay(
                Group {
                    Button {
                        if playersInfo.count > 0 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                deleteMode.toggle()
                            }
                        }
                    } label: {
                        DeletePlayer()
                    }
                }
                    .opacity(playersInfo.count > 0 ? 1 : 0)
                .padding(.horizontal, 40)
                ,alignment: .topTrailing
            )
            .overlay(
                Button {
                    if playersInfo.count >= 2 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showGameSettings = true
                        }
                    } else {
                        deleteMode = false
                        showToast = true
                    }
                } label: {
                    HStack (spacing: 0) {
                        Text("Configurar partida")
                            .font(.system(size: 15, weight: .heavy, design: .rounded))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 25, weight: .bold, design: .rounded))
                            .foregroundColor(.accentColor)

                    }
                    .padding(40)
                }, alignment: .bottomTrailing
                
            )
            .overlay(
                Toast(type: .error, title: "Error", message: "Tienes que añadir 2 jugadores mínimo", showToast: $showToast, duration: 1), alignment: .bottom
            )
        }
    }
}

struct AddPlayers_Previews: PreviewProvider {
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

    static var previews: some View {
        ZStack {
            Image("background")
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            AddPlayers(playersInfo: .constant(playersInfo), showGameSettings: .constant(false))
        }
        .previewInterfaceOrientation(.landscapeLeft)
        .preferredColorScheme(.dark)
    }
}
