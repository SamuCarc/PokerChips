//
//  Player.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 4/5/23.
//

import SwiftUI
import AnimatedNumber

enum AmountPosition {
    case bottom
    case top
    case left
    case right
}

struct Player: View {
    //MARK: Properties
    @Binding var playerInfo: PlayerInfo
    @Binding var isDealer:Bool
    @Binding var isPlaying:Bool
    @State private var displayedAmount: Double = 0
    @State private var displayedWinAmount: Double = 0
    @State private var displayedBet: Double = 0
    @State private var animateBet: Bool = false
    @State private var showAnimationDiscard: Bool = false
    @State private var startWinAnimationWin: Bool = false
    @State private var winAnimationAmount: Bool = false
    var animation : Namespace.ID

    let formatter = NumberFormatter()

    var amountPosition:AmountPosition = .top

    init(playerInfo: Binding<PlayerInfo>, isDealer: Binding<Bool>, isPlaying: Binding<Bool>, animation:Namespace.ID) {
        self._playerInfo = playerInfo
        self._isDealer = isDealer
        self._isPlaying = isPlaying
        self.animation = animation
        
        self.amountPosition = playerInfo.amountPosition.wrappedValue

        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        formatter.positiveSuffix = " €"
    }

    var body: some View {
        ZStack {
            
            //MARK: DISCARD ANIMATION
            DiscardCardsAnimation(showAnimation: $showAnimationDiscard, amountPosition: playerInfo.amountPosition)
            //MARK: WIN ANIMATION
                AnimatedNumber($displayedWinAmount, duration: 0.5, formatter: formatter)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .padding(EdgeInsets(top: 3, leading: 5, bottom: 3, trailing: 5))
                    .background(Color.green)
                    .cornerRadius(4)
                    .offset(x: 22, y: 35)
                    .foregroundColor(.white)
                    .zIndex(20)
                    .opacity(winAnimationAmount ? 1 : 0)

            //MARK: CHIPS
            ChipsAmount(totalAmount: $playerInfo.totalAmount)
                .padding()
                .offset(
                    x: amountPosition == .left ? -35 : amountPosition == .right ? 35 : 0, y: amountPosition == .top ? -30 : amountPosition == .bottom ? 30 : 0)
            if isDealer {
                DealerChip()
                    .matchedGeometryEffect(id: "dealer_change", in: animation)
                    .offset(x: amountPosition == .left ? -45 : amountPosition == .right ? 45 : amountPosition == .bottom ? -45 : 45, y: amountPosition == .top ? -30 : amountPosition == .bottom ? 30 : amountPosition == .left ? -35 : 35)
            }
            
            //MARK: ANIMATION WIN
            if startWinAnimationWin {
                ChipsAmount(totalAmount: $playerInfo.win)
                    .matchedGeometryEffect(id: "animation_win_\($playerInfo.id)", in: animation)
                    .padding()
                    .zIndex(10)
            }

            //MARK: BET
            if playerInfo.bet > 0 {
                AnimatedNumber($displayedBet, duration: 0.5, formatter: formatter)
                    .font(.system(size: 9, weight: .bold, design: .rounded))
                    .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(4)
                    .foregroundColor(.white)
                    .offset(x: amountPosition == .left ? -70 : amountPosition == .right ? 70 : 0, y: amountPosition == .top ? -55 : amountPosition == .bottom ? 55 : 20)
                    .zIndex(2)
                
                ChipsAmount(totalAmount: $playerInfo.bet)
                    .padding()
                    .offset(x: amountPosition == .left ? -70 : amountPosition == .right ? 70 : 0, y: amountPosition == .top ? -70 : amountPosition == .bottom ? 70 : 0)
                    .offset(y: animateBet ? 0 : amountPosition == .top ? 45 : amountPosition == .bottom ? -45 : 0)
                    .offset(x: animateBet ? 0 : amountPosition == .left ? 45 : amountPosition == .right ? -45 : 0)
                    .zIndex(1)
            }

            //MARK: AVATAR
                ZStack {

                    Avatar(avatar: $playerInfo.avatar.wrappedValue, status:$playerInfo.status, isPlaying: $isPlaying)

                    VStack (alignment: .center, spacing: 0) {
                        Text($playerInfo.alias.wrappedValue)
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .cornerRadius(4)
                            .foregroundColor(.accentColor)


                        AnimatedNumber($displayedAmount, duration: 0.5, formatter: formatter)
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .cornerRadius(4)
                            .foregroundColor(.white)
                    }
                    .padding(EdgeInsets(top: 2, leading: 3, bottom: 2, trailing: 3))
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(5)
                    .offset(x: playerInfo.amountPosition == .left || playerInfo.amountPosition == .right ? 0 : -65, y: playerInfo.amountPosition == .left || playerInfo.amountPosition == .right ? 50 : 0)

            }//:ZSTACK
                .offset(x: playerInfo.amountPosition == .left ? 25 : playerInfo.amountPosition == .right ? -25 : 0, y: playerInfo.amountPosition == .top ? 20 : playerInfo.amountPosition == .bottom ? -20 : 0)

            .onAppear {
                displayedAmount = Double(playerInfo.totalAmount)
                displayedBet = Double(playerInfo.bet)
                displayedWinAmount = Double(playerInfo.win)
                if playerInfo.bet > 0 {
                    withAnimation (.easeOut(duration: 0.5)) {
                        animateBet = true
                    }
                }
            }
            .onChange(of: playerInfo.totalAmount) { newValue in
                displayedAmount = Double(newValue)
            }
            .onChange(of: playerInfo.bet) { newBet in
                if newBet > 0 {
                    animateBet = false
                    withAnimation(.easeOut(duration: 0.5)) {
                        animateBet = true
                    }
                }
                displayedBet = Double(newBet)
            }
            .onChange(of: playerInfo.status) { newStatus in
                if newStatus == .fold || newStatus == .leftGame {
                    showAnimationDiscard = true
                } else {
                    showAnimationDiscard = false
                }
            }
            .onChange(of: playerInfo.win) { newWinValue in
                startWinAnimationWin = false
                displayedWinAmount = Double(newWinValue)
                winAnimationAmount = false
                if newWinValue > 0 {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        winAnimationAmount = true
                    }
                    withAnimation(.easeInOut(duration: 0.5).delay(2)) {
                        startWinAnimationWin = true
                    }
                    withAnimation(.easeInOut(duration: 0.3).delay(4)) {
                        winAnimationAmount = false
                    }
                    withAnimation(.easeInOut(duration: 0.3).delay(3)) {
                        startWinAnimationWin = false
                    }
                }
            }
        }//:ZSTACK
        .frame(width: 150, height: 100)
    }
}

struct Player_Previews: PreviewProvider {
    static var animation = Namespace().wrappedValue
    static private var playerInfo:PlayerInfo = PlayerInfo(totalAmount: 23456, status: .raise, avatar: "Avatar_9", alias: "Keyla", amountPosition: .left, bet: 121216, totalBet: 0, win: 8550)
    static private var playerInfo2:PlayerInfo = PlayerInfo(totalAmount: 23456, status: .raise, avatar: "Avatar_12", alias: "Samu", amountPosition: .right, bet: 121216, totalBet: 0, win: 8557)
    static private var playerInfo3:PlayerInfo = PlayerInfo(totalAmount: 23456, status: .raise, avatar: "Avatar_13", alias: "Naty", amountPosition: .top, bet: 121216, totalBet: 0, win: 8557)
    static private var playerInfo4:PlayerInfo = PlayerInfo(totalAmount: 23456, status: .raise, avatar: "Avatar_14", alias: "David", amountPosition: .bottom, bet: 121216, totalBet: 0, win: 8557)

    static var previews: some View {
        VStack (spacing: 100) {
            HStack {
                Player(playerInfo: .constant(playerInfo), isDealer: .constant(false), isPlaying: .constant(false), animation: animation)
                Player(playerInfo: .constant(playerInfo2), isDealer: .constant(true), isPlaying: .constant(false), animation: animation)

            }
            HStack {
                Player(playerInfo: .constant(playerInfo3), isDealer: .constant(false), isPlaying: .constant(false), animation: animation)
                Player(playerInfo: .constant(playerInfo4), isDealer: .constant(true), isPlaying: .constant(false), animation: animation)

            }
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
