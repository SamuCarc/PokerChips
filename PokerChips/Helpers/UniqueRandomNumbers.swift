//
//  UniqueRandomNumbers.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 4/5/23.
//

import Foundation
func uniqueRandomNumbers (count: Int, totalAvatars: Int) -> [Int] {
    var availableIndices = Set(1...totalAvatars)
    var selectedIndices: [Int] = []

    for _ in 0..<count {
        guard let randomIndex = availableIndices.randomElement() else { break }
        selectedIndices.append(randomIndex)
        availableIndices.remove(randomIndex)
    }

    return selectedIndices
}
