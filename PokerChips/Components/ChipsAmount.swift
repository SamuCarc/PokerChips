//
//  ChipsAmount.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 4/5/23.
//

import SwiftUI

struct ChipsAmount: View {
    @Binding var totalAmount: Int
    @State private var chipsNeeded: [PokerChip: Int] = [:]

    init(totalAmount: Binding<Int>) {
        self._totalAmount = totalAmount
        _chipsNeeded = State(initialValue: chipsForAmount(totalAmount.wrappedValue))
    }
    
    var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: 0))
        ]
        
        LazyVGrid(columns: columns, alignment: .center, spacing: 0) {
            ForEach(Array(chipsNeeded.enumerated()), id: \.offset) { index, chip in
                Chip(chip: chip.key, count: chip.value)
            }
        }
        .frame(width: 16, height: 16)
        .onChange(of: totalAmount) { newValue in
            chipsNeeded = chipsForAmount(newValue)
        }
    }
}

struct ChipsAmount_Previews: PreviewProvider {
    static var previews: some View {
        ChipsAmount(totalAmount: .constant(108558))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
