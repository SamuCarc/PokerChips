//
//  PlayerAddRow.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 15/6/23.
//

import SwiftUI

struct PlayerAddRow: View {
    var playerNumber: Int
    var player: PlayerInfo
    @Binding var isDeleteMode: Bool
    private func getPlayerStatus (number:Int) -> String {
        switch number {
        case 1:
            return "Repartidor"
        case 2:
            return "Ciega Pequeña"
        case 3:
            return "Ciega Grande"
        case 4:
            return "Primero en Jugar"
        default:
            return "Jugador"
        }
    }

    var body: some View {
        HStack (spacing: 15) {
            
            ZStack {
                Circle()
                    .stroke(isDeleteMode ? .red : Color.accentColor, lineWidth: 4)
                    .frame(width: 52, height: 52)
                
                if isDeleteMode {
                    Circle()
                        .fill(.black.opacity(0.6))
                        .frame(width: 47)
                        .zIndex(2)
                    Image(systemName: "minus")
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .foregroundColor(.red)
                        .zIndex(3)
                }
                
                Image(player.avatar)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(30)
                    .frame(width: 48)

                DealerChip()
                    .opacity(playerNumber == 1 ? 1 : 0)
                    .zIndex(4)
                    .offset(x: 20, y: 15)
            }
            
            VStack (alignment: .leading, spacing: 2) {
                Text(player.alias)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(isDeleteMode ? .red : .accentColor)
                    .lineLimit(1)
                
                Text(getPlayerStatus(number: playerNumber))
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .padding(EdgeInsets(top: 3, leading: 5, bottom: 3, trailing: 5))
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(4)
                    .foregroundColor(.white)
            }
        }
        .frame(width: 180, alignment: .leading)
        .padding(8)
    }
}

struct PlayerAddRow_Previews: PreviewProvider {
    static var playerInfo: PlayerInfo = PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_9", alias: "Samuel", amountPosition: .top, bet: 0, totalBet: 0, win: 0)
    static var playerInfo2: PlayerInfo = PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_14", alias: "Natalia Aldehuela", amountPosition: .top, bet: 0, totalBet: 0, win: 0)
    static var playerInfo3: PlayerInfo = PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_18", alias: "Ivan", amountPosition: .top, bet: 0, totalBet: 0, win: 0)
    static var playerInfo4: PlayerInfo = PlayerInfo(totalAmount: 20000, status: .none, avatar: "Avatar_22", alias: "Samuel Carcases", amountPosition: .top, bet: 0, totalBet: 0, win: 0)
    static var previews: some View {
        ZStack {
            Image("background")
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
                PlayerAddRow(playerNumber: 1, player: playerInfo, isDeleteMode: .constant(true))
                PlayerAddRow(playerNumber: 2, player: playerInfo2,isDeleteMode: .constant(false))
                PlayerAddRow(playerNumber: 3, player: playerInfo3, isDeleteMode: .constant(false))
                PlayerAddRow(playerNumber: 4, player: playerInfo4, isDeleteMode: .constant(true))

            }
        }
        .previewInterfaceOrientation(.landscapeLeft)
        .colorScheme(.dark)
    }
}
