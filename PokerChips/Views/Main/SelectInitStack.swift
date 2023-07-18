//
//  SelectInitStack.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 20/6/23.
//

import SwiftUI

struct SelectInitStack: View {
    @Binding var initialStack: Int
    let initStackArray: [Int] = [2000, 5000, 10000, 20000]

    var body: some View {
        VStack (spacing: 10) {
            Text("Selecciona la cantidad inicial")
                .foregroundColor(.accentColor)
                .font(.system(size: 20, weight: .bold, design: .rounded))

            HStack (spacing: 30) {
                ForEach(initStackArray.indices, id: \.self) { index in
                    let isSelected = initStackArray[index] == initialStack
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            initialStack = initStackArray[index]
                        }
                    } label: {
                        Text("\(initStackArray[index]) €")
                            .frame(width: 85, height: 40)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .background(isSelected ? Color.accentColor.opacity(0.7) : Color.accentColor.opacity(0.3))
                            .cornerRadius(40)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(Color.accentColor, lineWidth: isSelected ? 4 : 2)
                                    .opacity(isSelected ? 1 : 0.3)
                            )
                            .scaleEffect(isSelected ? 1.5 : 1)
                    }
                }
            }
            .frame(height: 60)
        }
    }
}

struct SelectInitStack_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Image("background")
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            SelectInitStack(initialStack: .constant(10000))
        }
        .padding()
        .frame(maxWidth: 620, maxHeight: 350)
        .overlay(
            Button {
                
            } label: {
                ButtonStartGame()
            }
            , alignment: .bottom
        )
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
