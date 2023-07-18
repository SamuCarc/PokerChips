//
//  PlayerInfoRow.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 7/5/23.
//

import SwiftUI

struct PlayerInfoRow: View {
    var playerNumber: Int
    var bigBlind: Int
    var maxPlayer: Int
    var player: PlayerInfo
    let formatter = NumberFormatter()
    init(player: PlayerInfo, playerNumber: Int, bigBlind: Int, maxPlayer: Int) {
        self.player = player
        self.playerNumber = playerNumber
        self.bigBlind = bigBlind
        self.maxPlayer = maxPlayer
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        formatter.positiveSuffix = " €"
    }
    @State private var animationStarted = false
    @State private var animationEnd = false

    private func getPlayerStatus (number:Int) -> String {
        switch number {
        case 1:
            return "Repartidor"
        case 2:
            let smallBlindFormatted = formatter.string(from: NSNumber(value: bigBlind / 2)) ?? ""
            return "Ciega Pequeña: \(smallBlindFormatted)"
        case 3:
            let bigBlindFormatted = formatter.string(from: NSNumber(value: bigBlind)) ?? ""
            return "Ciega Grande: \(bigBlindFormatted)"
        case 4:
            return "Primero en Jugar"
        default:
            return "Jugador"
        }
    }

    var body: some View {
        HStack (spacing: 4) {
            Text(playerNumber.description)
                .foregroundColor(.accentColor)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .frame(width: 30, height: 30)
                .background(Color.black.opacity(0.8))
                .cornerRadius(20)

            Avatar(avatar: player.avatar, status:.constant(player.status), isPlaying: .constant(false))
                .padding(.horizontal, 20)

            VStack (alignment: .leading, spacing: 2) {
                Text(player.alias)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                
                
                Text(getPlayerStatus(number: playerNumber))
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .padding(EdgeInsets(top: 3, leading: 5, bottom: 3, trailing: 5))
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(4)
                    .foregroundColor(.white)
            }
            
            DealerChip()
                .padding(.horizontal)
                .opacity(playerNumber == 1 ? 1 : 0)
        }
        .opacity(animationStarted && !animationEnd ? 1 : 0)
        .offset(x: animationStarted ? 0 : -150)
        .offset(x: animationEnd ? 150 : 0)
        .padding(.vertical, 8)
        .onAppear {
            animationEnd = false
            animationStarted = false

            if (playerNumber > (maxPlayer * 2)) {
                withAnimation(.easeInOut(duration: 0.3).delay(0.1 * Double(playerNumber - (maxPlayer * 2)) + 6)) {
                    animationStarted = true
                }
                withAnimation(.easeInOut(duration: 0.3).delay(0.1 * Double(playerNumber - (maxPlayer * 2)) + 8.5)) {
                    animationEnd = true
                }
            } else if (playerNumber > maxPlayer) {
                withAnimation(.easeInOut(duration: 0.3).delay(0.1 * Double(playerNumber - maxPlayer) + 3)) {
                    animationStarted = true
                }
                withAnimation(.easeInOut(duration: 0.3).delay(0.1 * Double(playerNumber - maxPlayer) + 5.5)) {
                    animationEnd = true
                }
            } else {
                withAnimation(.easeInOut(duration: 0.3).delay(0.1 * Double(playerNumber - 1) + 0)) {
                    animationStarted = true
                }
                withAnimation(.easeInOut(duration: 0.3).delay(0.1 * Double(playerNumber - 1) + 2.5)) {
                    animationEnd = true
                }
            }
        }
    }
}

struct PlayerInfoRow_Previews: PreviewProvider {
    static var playersInfo: [PlayerInfo] = [
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_4", alias: "Naty", amountPosition: .right, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_5", alias: "Samu", amountPosition: .bottom, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_7", alias: "Alicia", amountPosition: .bottom, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_6", alias: "Mario", amountPosition: .left, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_8", alias: "Kino", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_9", alias: "Keyla2", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_9", alias: "Keyla3", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_9", alias: "Keyla4", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_9", alias: "Keyla5", amountPosition: .top, bet: 0, totalBet: 0, win: 0),
        PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_9", alias: "Keyla6", amountPosition: .top, bet: 0, totalBet: 0, win: 0)
    ]

    static var previews: some View {
        ShowPlayers(playersInfo: playersInfo, initialStack: 20000, showModalPlayers: .constant(true))
    }
}
