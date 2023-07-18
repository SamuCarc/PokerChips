//
//  ShowPlayers.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 7/5/23.
//

import SwiftUI

struct ShowPlayers: View {
    var playersInfo: [PlayerInfo]
    var initialStack: Int

    var firstCount:Int = 0
    var secondCount:Int = 0
    var thirdCount:Int = 0
    var maxPlayers:Int = 4
    let formatter = NumberFormatter()
    @Binding var showModalPlayers: Bool
    init(playersInfo: [PlayerInfo], initialStack: Int, showModalPlayers: Binding<Bool>) {
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        formatter.positiveSuffix = " €"

        self.playersInfo = playersInfo
        self.initialStack = initialStack
        self._showModalPlayers = showModalPlayers
        let maxPlayerSecond:Int = maxPlayers * 2
        
        firstCount = (playersInfo.count > maxPlayers) ? maxPlayers : playersInfo.count
        secondCount = maxPlayers == firstCount && playersInfo.count > maxPlayerSecond  ? 4 : playersInfo.count - 4
        thirdCount = playersInfo.count > maxPlayerSecond ? playersInfo.count - maxPlayerSecond : 0
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .edgesIgnoringSafeArea(.all)
                .foregroundStyle(.ultraThinMaterial)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showModalPlayers = false
                    }
                }

            VStack (spacing: 0) {
                
                HStack {
                    Text("Jugadores: ")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                    + Text(playersInfo.count.description)
                        .foregroundColor(.primary)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                    
                    Spacer()
                    Text("Stack inicial: ")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                    + Text(formatter.string(from: NSNumber(value: initialStack)) ?? ""
                    )
                    .foregroundColor(.primary)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    
                }//:HASTACK
                .padding(.horizontal)
                
                ZStack {
                    VStack (alignment: .leading, spacing: 0) {
                        ForEach(0..<firstCount, id: \.self) { index in
                            PlayerInfoRow(player: playersInfo[index], playerNumber: index + 1, bigBlind: 200, maxPlayer: maxPlayers)
                            
                            if firstCount - 1 != index {
                                Divider()
                                    .overlay(Color.accentColor.opacity(0.1))
                            }
                        }
                        Spacer()
                    }
                    .padding(.top, 8)
                    
                    if (secondCount > 0) {
                        VStack (alignment: .leading, spacing: 0) {
                            ForEach(0..<secondCount, id: \.self) { index in
                                PlayerInfoRow(player: playersInfo[index + maxPlayers], playerNumber: index + maxPlayers + 1, bigBlind: 200, maxPlayer: maxPlayers)
                                
                                if secondCount - 1 != index {
                                    Divider()
                                        .opacity(0)
                                }
                            }
                            Spacer()
                        }
                        .padding(.top, 8)
                    }
                    
                    if (thirdCount > 0) {
                        VStack (alignment: .leading, spacing: 0) {
                            ForEach(0..<thirdCount, id: \.self) { index in
                                PlayerInfoRow(player: playersInfo[index + (maxPlayers * 2)], playerNumber: index + (maxPlayers * 2) + 1, bigBlind: 200, maxPlayer: maxPlayers)
                                
                                if thirdCount - 1 != index {
                                    Divider()
                                        .opacity(0)
                                }
                            }
                            Spacer()
                        }
                        .padding(.top, 8)
                    }
                    
                }//:ZSTACK
            }//:VSTACK
            .frame(width: 350, height: 300)
            .padding()
            .background(.thinMaterial)
            .cornerRadius(10)
            .shadow(radius: 20)
        }
        .opacity(showModalPlayers ? 1 : 0)
    }
}

struct ShowPlayers_Previews: PreviewProvider {
    static private var playersInfo: [PlayerInfo] = [
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_4", alias: "Naty", amountPosition: .right, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_5", alias: "Samu", amountPosition: .bottom, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_7", alias: "Alicia", amountPosition: .bottom, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_6", alias: "Mario", amountPosition: .left, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_8", alias: "Kino", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_9", alias: "Keyla", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_9", alias: "Keyla", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_9", alias: "Keyla", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_9", alias: "Keyla", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_9", alias: "Keyla", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
    ]

    static var previews: some View {
        ShowPlayers(playersInfo: playersInfo, initialStack: 20000, showModalPlayers: .constant(true))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
