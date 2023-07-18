//
//  BackgroundCreatePlayer.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 3/6/23.
//

import SwiftUI

struct BackgroundCreatePlayer: View {
    @Binding var backgroundName:String
    var body: some View {
        ZStack {
            Image(backgroundName)
                .blur(radius: 8)
        }
    }
}

struct BackgroundCreatePlayer_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundCreatePlayer(backgroundName: .constant("Avatar_28"))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
