//
//  ScrollingHStackModifier.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 26/5/23.
//

import SwiftUI

struct ScrollingHStackModifier: ViewModifier {
    
    @Binding var scrollOffset: CGFloat
    @Binding var stopOffset: Bool
    @State private var initialOffset: CGFloat = 0
    @State private var isDragging: Bool = false

    var itemsCount: Int
    var itemWidth: CGFloat
    var itemSpacing: CGFloat
    var scrollSize: CGFloat
    @Binding var selectedIndex: Int
    var centerPadding: CGFloat {
        scrollSize/2 - itemWidth/2
    }
    var itemSize: CGFloat {
        itemWidth + itemSpacing
    }

    var contentWidth: CGFloat {
        CGFloat(itemsCount) * itemWidth + CGFloat(itemsCount - 1) * itemSpacing
    }


    func body(content: Content) -> some View {
        content
            .offset(x: scrollOffset, y: 0)
            .gesture(DragGesture()
                .onChanged({ event in
                    if !stopOffset {
                        isDragging = true
                        scrollOffset = initialOffset + event.translation.width
                        
                        // Calculate which item we are closest to using the defined size
                        var index = -scrollOffset / (itemWidth + itemSpacing)
                        
                        // Should we stay at current index or are we closer to the next item...
                        let offset = -CGFloat(Int(index)) * itemSize
                        if scrollOffset < (offset - (itemSize/2)) {
                            index += 1
                        } else if scrollOffset > (offset + (itemSize/2)) {
                            index -= 1
                        } else {
                            index = CGFloat(Int(index))
                        }

                        // Protect from scrolling out of bounds
                        if (index < 0) {
                            index = CGFloat(itemsCount) - 1
                        }
                        else if (index >= CGFloat(itemsCount)) {
                            index = 0
                        }

                        if selectedIndex != Int(index) {
                            withAnimation {
                                selectedIndex = Int(index)
                            }
                        }
                    }
                })
                .onEnded({ event in
                    isDragging = false
                    initialOffset = scrollOffset // Instead, set initialOffset to our current scrollOffset, ready for next drag event
                    
                    // Calculate which item we are closest to using the defined size
                    var index = -scrollOffset / itemSize
                    
                    // Should we stay at current index or are we closer to the next item...
                    let offset = -CGFloat(Int(index)) * itemSize
                    if scrollOffset < (offset - (itemSize/2)) {
                        index += 1
                    } else if scrollOffset > (offset + (itemSize/2)) {
                        index -= 1
                    } else {
                        index = CGFloat(Int(index))
                    }

                    // Protect from scrolling out of bounds
                    if (index < 0) {
                        index = CGFloat(itemsCount) - 1
                    }
                    else if (index >= CGFloat(itemsCount)) {
                        index = 0
                    }

                    if selectedIndex == Int(index) {
                        let newOffset = -CGFloat(selectedIndex) * itemSize
                        
                        withAnimation {
                            scrollOffset = newOffset
                            initialOffset = newOffset
                        }
                    }
                })
            )
            .onChange(of: selectedIndex) { newIndex in
                if !isDragging {
                    let newOffset = -CGFloat(newIndex) * itemSize
                    
                    withAnimation {
                        scrollOffset = newOffset
                        initialOffset = newOffset
                    }
                }
            }
            .onAppear {
                let newOffset = -CGFloat(selectedIndex) * itemSize
                
                withAnimation {
                    scrollOffset = newOffset
                    initialOffset = newOffset
                }
            }
    }
}

struct ScrollingHStackModifier_Previews: PreviewProvider {
    static let avatarCount = 16
    static let scrollSize:CGFloat = 350
    static let sizeAvatar:CGFloat = 80
    static let spaceBetweenAvatars: CGFloat = 15
    static var centerPadding: CGFloat {
        scrollSize / 2 - sizeAvatar/2
    }
    @State static var scrollOffset:CGFloat = -(CGFloat(selectedIndex) * sizeAvatar) - (CGFloat(selectedIndex) * spaceBetweenAvatars)
    
    @State static var selectedIndex:Int = 6
    @State static var stopOffset:Bool = false

    static var previews: some View {
        VStack {
            Text(scrollOffset.description)
            HStack(alignment: .center, spacing: spaceBetweenAvatars) {
                ForEach(0..<avatarCount, id: \.self) { i in
                        Image("Avatar_\(i+1)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: sizeAvatar, height: sizeAvatar)
                }
                .modifier(ScrollingHStackModifier(scrollOffset: $scrollOffset, stopOffset: $stopOffset, itemsCount: avatarCount, itemWidth: sizeAvatar, itemSpacing: spaceBetweenAvatars, scrollSize: scrollSize, selectedIndex: $selectedIndex))
                
            }
            .padding(.horizontal, centerPadding)
            .frame(width: scrollSize, alignment: .leading)
            .clipped()
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
