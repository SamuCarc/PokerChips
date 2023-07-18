//
//  Avatar.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 4/5/23.
//

import SwiftUI

enum PlayerAction:String {
    case none = ""
    case smallBlind = "C. pequeña"
    case bigBlind = "C. grande"
    case fold = "Se retira"
    case check = "Pasa"
    case call = "Iguala"
    case raise = "Sube"
    case allIn = "ALL IN"
    case winner = "GANADOR"
    case leftGame = "Terminó"
    
    var color: Color {
        switch self {
        case .smallBlind, .bigBlind, .check, .fold:
            return .gray
        case .call:
            return .green
        case .raise:
            return .yellow
        case .allIn:
            return .red
        case .winner:
            return .accentColor
        default:
            return .black
        }
    }

}

struct Avatar: View {
    var avatar:String
    @Binding var status:PlayerAction
    @Binding var isPlaying:Bool
    
    @State var playingAnimation:Bool = false
    
    var body: some View {
        ZStack {
                
            Circle()
                .stroke(Color.accentColor, lineWidth: 4)
                .frame(width: 52, height: 52)

            if status == .leftGame || status == .fold || status == .allIn {
                Circle()
                    .fill(.black.opacity(0.3))
                    .frame(width: 47)
                    .zIndex(1)
            }
            if isPlaying {
                Circle()
                    .fill(.white.opacity(0.15))
                    .frame(width: 47)
                    .zIndex(1)
            }

            if (status != .none && !isPlaying) {
                Text(status.rawValue)
                    .font(.system(size: status == .winner ? 11 : 10, weight: .bold, design: .rounded))
                    .frame(width: status == .winner ? 62 : 58)
                    .lineLimit(1)
                    .padding(EdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2))
                    .background(status.color)
                    .cornerRadius(3)
                    .foregroundColor(.white)
                    .offset(x: 0, y:22)
                    .zIndex(2)
            }
            Image(avatar)
                .resizable()
                .scaledToFit()
                .cornerRadius(30)
                .frame(width: 48)
                .overlay(
                    Circle()
                        .stroke(Color.accentColor, lineWidth: 5)
                        .frame(width: 55, height: 55)
                        .opacity(isPlaying ? 1 : 0)
                )
                .overlay(
                    Group {
                        Circle()
                            .stroke(Color.accentColor, lineWidth: 3)
                            .frame(width: 57, height: 57)
                            .scaleEffect(playingAnimation ? 1.4 : 1)
                            .opacity(playingAnimation ? 0 : 1)
                    }
                    .opacity(isPlaying ? 1 : 0)
                )
            }
        .onAppear {
            if isPlaying {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: false)) {
                    playingAnimation = true
                }
            }
        }
        .onChange(of: isPlaying) { newValue in
                if newValue {
                    withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: false)) {
                        playingAnimation = true
                    }
                }
            }

    }
}

struct Avatar_Previews: PreviewProvider {
    static var previews: some View {
        Avatar(avatar: "Avatar_4", status: .constant(.smallBlind), isPlaying: .constant(false))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
