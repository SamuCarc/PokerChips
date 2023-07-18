//
//  SelectColorTable.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 20/6/23.
//

import SwiftUI

struct SelectColorTable: View {
    @Binding var colorSelected: ColorTable
    var body: some View {
        VStack (spacing: 10) {
            Text("Selecciona el color de la mesa")
                .foregroundColor(.accentColor)
                .font(.system(size: 20, weight: .bold, design: .rounded))
    
            HStack (spacing: 25) {
                ForEach(ColorTable.allCases, id: \.self) { colorTable in
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            colorSelected = colorTable
                        }
                    } label: {
                        ColorTableComponent(colorTable: colorTable, isSelected: .constant(colorTable == colorSelected))
                    }
                }
                
            }
            .frame(height: 60)
        }
    }
}

struct SelectColorTable_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Image("background")
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            SelectColorTable(colorSelected: .constant(.green))
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
