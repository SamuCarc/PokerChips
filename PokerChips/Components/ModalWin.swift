//
//  ModalWin.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 15/5/23.
//

import SwiftUI

struct ModalWin: View {
    @Binding var playersInfo: [PlayerInfo]
    @Binding var gameInfo: GameInfo
    @Binding var showModalWin: Bool

    @State var firstPlacePlayers: Set<UUID> = []
    @State var secondPlacePlayers: Set<UUID> = []
    @State var thirdPlacePlayers: Set<UUID> = []

    var activePlayers: [PlayerInfo] {
        playersInfo.filter { $0.status != .leftGame && $0.status != .fold }
    }

    var body: some View {
            
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .edgesIgnoringSafeArea(.all)
                .foregroundStyle(.ultraThinMaterial)
            VStack (spacing: 0) {
                ScrollView (showsIndicators: false) {
                    VStack (spacing: 0) {
                    HStack {
                        Text("Selecciona el ganador o ganadores!")
                            .foregroundColor(.accentColor)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }//:HASTACK
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    
                    //FIRST POSITION
                    ScrollView (.horizontal, showsIndicators: false) {
                        HStack (alignment: .center,spacing: 0) {
                            Text("Puesto 1")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 15)
                                .background(Color.black.opacity(0.8))
                                .cornerRadius(20)
                                .foregroundColor(.accentColor)
                            
                            ForEach(activePlayers, id: \.id) { player in
                                if !secondPlacePlayers.contains(player.id) && !thirdPlacePlayers.contains(player.id) {
                                    SelectedPlayerRow(avatar: player.avatar, alias: player.alias, isSelected: .constant(firstPlacePlayers.contains(player.id)))
                                        .onTapGesture {
                                            selectPlayerForPosition(id: player.id, position: 1)
                                        }
                                }
                            }
                        }
                        Spacer()
                    }//:FIRST POSITION
                    
                    if !firstPlacePlayers.isEmpty  {
                        //SECOND POSITION
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack (alignment: .center,spacing: 0) {
                                Text("Puesto 2")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 15)
                                    .background(Color.black.opacity(0.8))
                                    .cornerRadius(20)
                                    .foregroundColor(.accentColor)
                                
                                ForEach(activePlayers, id: \.id) { player in
                                    if !firstPlacePlayers.contains(player.id) && !thirdPlacePlayers.contains(player.id) {
                                        SelectedPlayerRow(avatar: player.avatar, alias: player.alias, isSelected: .constant(secondPlacePlayers.contains(player.id)))
                                            .onTapGesture {
                                                selectPlayerForPosition(id: player.id, position: 2)
                                            }
                                    }
                                }
                            }//:VSTACK
                            Spacer()
                        }
                    }//:SECONDPOSITION
                    
                    
                    //THIRD POSITION
                    if !firstPlacePlayers.isEmpty && !secondPlacePlayers.isEmpty  {
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack (alignment: .center,spacing: 0) {
                                Text("Puesto 3")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 15)
                                    .background(Color.black.opacity(0.8))
                                    .cornerRadius(20)
                                    .foregroundColor(.accentColor)
                                
                                ForEach(activePlayers, id: \.id) { player in
                                    if !firstPlacePlayers.contains(player.id) && !secondPlacePlayers.contains(player.id) {
                                        SelectedPlayerRow(avatar: player.avatar, alias: player.alias, isSelected: .constant(thirdPlacePlayers.contains(player.id)))
                                            .onTapGesture {
                                                selectPlayerForPosition(id: player.id, position: 3)
                                            }
                                    }
                                }
                            }//:VSTACK
                            Spacer()
                        }
                        
                    }//:THIRDPOSITION
                }
                    
                }//:SCROLLVIEW
                .onChange(of: firstPlacePlayers) { _ in
                    if firstPlacePlayers.isEmpty {
                        secondPlacePlayers.removeAll()
                        thirdPlacePlayers.removeAll()
                    }
                }
                .onChange(of: secondPlacePlayers) { _ in
                    if secondPlacePlayers.isEmpty {
                        thirdPlacePlayers.removeAll()
                    }
                }
                
                Button  {
                    if !firstPlacePlayers.isEmpty {
                        calculateWinnings(players: &playersInfo, firstPlacePlayers: &firstPlacePlayers, secondPlacePlayers: &secondPlacePlayers, thirdPlacePlayers: &thirdPlacePlayers)
                        showModalWin = false
                    }
                } label: {
                    ButtonWin(isDisabled: .constant(firstPlacePlayers.isEmpty), text: "Aceptar")
                }
            }//:VSTACK
            .frame(width: 500, height: 320)
            .padding()
            .background(.thinMaterial)
            .cornerRadius(10)
            .shadow(radius: 20)
        }//:ZSTACK

    }

    private func selectPlayerForPosition(id: UUID, position: Int) {
        withAnimation (.easeInOut(duration: 0.1)) {
            switch position {
            case 1:
                if firstPlacePlayers.contains(id) {
                    firstPlacePlayers.remove(id)
                } else {
                    firstPlacePlayers.insert(id)
                }
            case 2:
                if secondPlacePlayers.contains(id) {
                    secondPlacePlayers.remove(id)
                } else {
                    secondPlacePlayers.insert(id)
                }
            case 3:
                if thirdPlacePlayers.contains(id) {
                    thirdPlacePlayers.remove(id)
                } else {
                    thirdPlacePlayers.insert(id)
                }
            default:
                break
            }
        }
    }
}


struct ModalWin_Previews: PreviewProvider {
    static private var playersInfo: [PlayerInfo] = [
        PlayerInfo(totalAmount: 20000, status: .leftGame, avatar: "Avatar_4", alias: "Naty", amountPosition: .right, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .fold, avatar: "Avatar_5", alias: "Samu", amountPosition: .bottom, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_7", alias: "Alicia", amountPosition: .bottom, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_6", alias: "Mario", amountPosition: .left, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_8", alias: "Kino", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_9", alias: "Keyla", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_14", alias: "Keyla", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_16", alias: "Keyla", amountPosition: .top, bet: 0, totalBet: 0, win: 0)
    ]
        
    static private var gameInfo:GameInfo = GameInfo(bigBlind: 200, raiseBlind: 2, initialStack: 21233, dealerIndex: 0, playingIndex: 0, stage: .preFlop, pot: 0, colorTable: .green)

    static var previews: some View {
        VStack {
        }
        .overlay (
            ModalWin(playersInfo: .constant(playersInfo), gameInfo: .constant(gameInfo), showModalWin: .constant(false))
        )
        .previewInterfaceOrientation(.landscapeLeft)
    }

}
