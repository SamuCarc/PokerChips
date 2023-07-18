//
//  CountChips.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 4/5/23.
//

import Foundation

func chipsForAmount(_ amount: Int) -> [PokerChip: Int] {
    var remainingAmount = amount
    var chipsCount: [PokerChip: Int] = [:]

    for chip in PokerChip.allCases.sorted(by: { $0.rawValue > $1.rawValue }) {
        let count = remainingAmount / chip.rawValue
        if count > 0 {
            chipsCount[chip] = count
            remainingAmount -= count * chip.rawValue
        }
        
        if remainingAmount == 0 {
            break
        }
    }
    
    return chipsCount
}
