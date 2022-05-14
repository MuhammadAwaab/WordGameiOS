//
//  GameStateManager.swift
//  WordGame
//
//  Created by XiSYS Creatives on 14/05/2022.
//

import Foundation


protocol GameStateProtocol {
    func refreshGameSettings()
    func gameEndCriteriaReached()
    
    var correctChoices: Int {get set}
    var incorrectChoices: Int {get set}
    var notifyGameEndReached:(() -> Void)? {get set}
    var showNextPairing:(() -> Void)? {get set}

}

class GameStateManager: GameStateProtocol {
    
    let pairingsAllowed: Int
    let wrongChoicesAllowed: Int
    
    var notifyGameEndReached:(() -> Void)?
    var showNextPairing:(() -> Void)?
    
    var correctChoices: Int {
        didSet {
            if correctChoices + incorrectChoices == pairingsAllowed {
                self.gameEndCriteriaReached()
            } else if correctChoices != 0 {
                self.showNextPairing?()
            }
        }
    }
    
    var incorrectChoices: Int {
        didSet {
            if incorrectChoices == wrongChoicesAllowed {
                self.gameEndCriteriaReached()
            } else if incorrectChoices != 0 {
                self.showNextPairing?()
            }
        }
    }
    
    
    init(_ numberOfPairingsAllowed: Int = 1, _ wrongChoicesAllowed: Int = 1) {
        self.pairingsAllowed = numberOfPairingsAllowed
        self.wrongChoicesAllowed = wrongChoicesAllowed
        correctChoices = 0
        incorrectChoices = 0
    }
    
    func refreshGameSettings() {
        correctChoices = 0
        incorrectChoices = 0
    }
    
    func gameEndCriteriaReached() {
        self.notifyGameEndReached?()
    }
    
    
}
