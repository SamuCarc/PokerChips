//
//  SelectAvatar.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 19/5/23.
//

import SwiftUI
import Combine

struct SelectAvatar: View {
    let avatarCount = 28
    @Binding var selectedAvatarIndex:Int
    @Binding var selectedAnimation:Bool
    @State var scrollOffset:CGFloat = 0
    var animation : Namespace.ID
    @Binding var nameAnimation:Bool

    let scrollSize:CGFloat = 620
    let sizeAvatar:CGFloat = 220
    let spaceBetweenAvatars: CGFloat = -10
    var centerPadding: CGFloat {
        scrollSize / 2 - sizeAvatar/2
    }
    var rowSize: CGFloat {
        sizeAvatar + spaceBetweenAvatars
    }

    var body: some View {
        ZStack {
            AvatarSelectionRow
                .padding(.horizontal, centerPadding)
                .padding(.vertical, 30)
                .padding(.top, 8)
                .frame(width: scrollSize, alignment: .leading)
                .clipped()
                .overlay(
                    Text("Selecciona un avatar")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .padding(EdgeInsets(top: 3, leading: 5, bottom: 3, trailing: 5))
                    ,alignment: .top
                )
        }//:ZSTACK
        .mask {
            LinearGradient(colors: [.clear, .black, .black, .clear], startPoint: .leading, endPoint: .trailing)
        }
        .padding(.horizontal)
        .overlay(
            Button {
                actionButtonLeft()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 50, weight: .bold, design: .rounded))
            }, alignment: .leading)
        .overlay(
            Button {
                actionButtonRight()
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 50, weight: .bold, design: .rounded))
            }
            , alignment: .trailing
        )
        .onChange(of: selectedAvatarIndex) { iAvatar in
            Feedback.vibrate()
        }
    }

    var AvatarSelectionRow: some View {
        HStack(alignment: .center, spacing: spaceBetweenAvatars) {
            ForEach(0..<avatarCount, id: \.self) { i in
                AvatarView(for: i)
            }
            .allowsHitTesting(!selectedAnimation)
            .modifier(ScrollingHStackModifier(scrollOffset: $scrollOffset, stopOffset: $selectedAnimation, itemsCount: avatarCount, itemWidth: sizeAvatar, itemSpacing: spaceBetweenAvatars, scrollSize: scrollSize, selectedIndex: $selectedAvatarIndex))
        }
    }
    
    func AvatarView(for index: Int) -> some View {
        Group {
                Image("Avatar_\(index+1)")
                    .resizable()
                    .cornerRadius(sizeAvatar/2)
                    .matchedGeometryEffect(id: selectedAvatarIndex == index && selectedAnimation ? "animation_name" : "animation_name\(index)", in: animation)
                    .overlay(
                        Circle()
                            .stroke(Color.accentColor, lineWidth: selectedAvatarIndex == index ? 5 : 0)
                            .matchedGeometryEffect(id: selectedAvatarIndex == index && selectedAnimation ? "animation_name_circle" : "animation_name_circle\(index)", in: animation)
                            .shadow(color: selectedAvatarIndex == index ? Color.accentColor : Color.clear, radius: 5) // Add glow effect
                            .frame(width: sizeAvatar, height: sizeAvatar)
                            .opacity(selectedAvatarIndex == index ? 1 : 0)
                    )
                    .frame(width: sizeAvatar, height: sizeAvatar)
                    .scaleEffect(scaleForElement(index: index))
                    .scaleEffect(selectedAvatarIndex == index && selectedAnimation ? 1.1 : 1)
                    .zIndex(selectedAvatarIndex == index ? 2 : 1)
        }
        .onTapGesture {
            onTapAvatar(index: index)
        }
    }

    private func onTapAvatar(index: Int) {
        if !selectedAnimation {
            if selectedAvatarIndex == index {
                withAnimation (.spring(response: 0.4, dampingFraction: 0.6)) {
                    selectedAnimation = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation (.easeInOut(duration: 0.5)) {
                        nameAnimation = true
                    }
                }
            } else {
                selectedAvatarIndex = index
            }
        }
    }
    
    private func actionButtonLeft() {
        if !selectedAnimation {
            if selectedAvatarIndex > 0 {
                withAnimation (.easeInOut(duration: 0.5)) {
                    selectedAvatarIndex -= 1
                }
            } else {
                withAnimation (.easeInOut(duration: 0.5)) {
                    selectedAvatarIndex = avatarCount - 1
                }
            }
        }
    }

    private func actionButtonRight() {
        if !selectedAnimation {
            if selectedAvatarIndex + 1 < avatarCount {
                withAnimation (.easeInOut(duration: 0.5)) {
                    selectedAvatarIndex += 1
                }
            } else {
                withAnimation (.easeInOut(duration: 0.5)) {
                    selectedAvatarIndex = 0
                }
            }
        }
    }
    
    private func scaleForElement(index:Int) -> CGFloat {
        let widthAvatar = sizeAvatar + spaceBetweenAvatars
        let centerPosition = widthAvatar * CGFloat(index)
        let distanceFromCenter = abs(-scrollOffset - centerPosition)
        let scale = max(0.5, 1 - distanceFromCenter/scrollSize)
        return scale
    }
}

struct TestAvatar: View {
    @State var selectedAvatarIndex:Int = 3
    @State var selectedAnimation:Bool = false
    @Namespace var animation

    var body: some View {
        SelectAvatar(selectedAvatarIndex: $selectedAvatarIndex, selectedAnimation: $selectedAnimation, animation: animation, nameAnimation: .constant(true))
    }
}



struct SelectAvatar_Previews: PreviewProvider {
    static var previews: some View {
        TestAvatar()
            .previewInterfaceOrientation(.landscapeLeft)
            .preferredColorScheme(.dark)
    }
}
