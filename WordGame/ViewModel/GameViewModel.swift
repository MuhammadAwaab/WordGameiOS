//
//  GameViewModel.swift
//  WordGame
//
//  Created by XiSYS Creatives on 14/05/2022.
//

import Foundation

protocol GameViewModelProtocol {
    func generateNumberForWrongPairingOtherThan(numberToAvoid: Int) -> Int
    func getTimeForAttempt() -> Int
    func randomPercent() -> Double
    func startGame()
    func restartGame()
    func makeRandomNumberList(_ numberOfPairings: Int) -> [Int]
    func getCorrectAnswersValue() -> String
    func getWrongAnswersValues() -> String
    func getEnglishWordToDisplay() -> String
    func getSpanishWordToDisplay() -> String
    func userSelectedWrong()
    func userSelectedCorrect()
}


class GameViewModel: GameViewModelProtocol {
    
    let englishWordKey = "text_eng"
    let spanishWordKey = "text_spa"
    
    var englishWordToDisplay = ""
    var spanishWordToDisplay = ""
    
    private var isShowingRightOption = true
    private var wordListDataArray: [[String: String]] = []
    private var randomNumberList: [Int] = []
    private var numberListPoint: Int = 0
    private var countdown: Timer?
    
    private let provider: DataProviderProtocol
    private var stateManager: GameStateProtocol
    
    var updateView:(() -> Void)?
    var showEndDialogue:(() -> Void)?
    
    init(provider: DataProviderProtocol = DataProvider()) {
        self.provider = provider
        self.stateManager = GameStateManager(provider.getNumberOfPairingsToShow(), provider.getIncorrectAttemptsAllowed())
        makeBindingsWithHelpers()
    }
    
    func startGame() {
        self.provider.fetchAndProvideWordList { wordList in
            if let listToShow = wordList {
                self.wordListDataArray = listToShow
                self.randomNumberList = self.makeRandomNumberList(self.provider.getNumberOfPairingsToShow())
                self.startGeneratingPairs()

            }
        }
    }
    
    func restartGame() {
        countdown?.invalidate()
        englishWordToDisplay = ""
        spanishWordToDisplay = ""
        numberListPoint = 0
        isShowingRightOption = true
        self.randomNumberList = self.makeRandomNumberList(self.provider.getNumberOfPairingsToShow())
        self.stateManager.refreshGameSettings()
        self.startGeneratingPairs()
    }
    
    private func makeBindingsWithHelpers() {
        
        self.stateManager.notifyGameEndReached = {[unowned self] in
            self.showEndDialogue?()
        }
        
        self.stateManager.showNextPairing = {[unowned self] in
            startGeneratingPairs()
        }
        
    }
    
    private func startGeneratingPairs() {
        switch randomPercent() {
        case 0..<25:
            self.isShowingRightOption = true
            let randomNumberListItem = randomNumberList[numberListPoint]
            let pairingDataToShow = wordListDataArray[randomNumberListItem]
            if let englishWord = pairingDataToShow[englishWordKey], let spanishWord = pairingDataToShow[spanishWordKey] {
                self.updateViewWithWords(english: englishWord, spanish: spanishWord)
            }
            
        default:
            self.isShowingRightOption = false
            let randomNumberListItem = randomNumberList[numberListPoint]
            let pairingDataToShow = wordListDataArray[randomNumberListItem]
            let wrongPairingData = wordListDataArray[generateNumberForWrongPairingOtherThan(numberToAvoid: randomNumberListItem)]
            if let englishWord = pairingDataToShow[englishWordKey], let spanishWord = wrongPairingData[spanishWordKey] {
                self.updateViewWithWords(english: englishWord, spanish: spanishWord)
            }
        }
    }
    
    private func updateViewWithWords(english: String, spanish: String) {
        numberListPoint += 1
        self.englishWordToDisplay = english
        self.spanishWordToDisplay = spanish
        
        self.updateView?()
        var runCount = 0
        countdown = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            runCount += 1
            if runCount == self.provider.getTimeAllowedForAttempt() {
                self.countdown?.invalidate()
                self.stateManager.incorrectChoices = self.stateManager.incorrectChoices + 1
            }
        }
    }
    
    func generateNumberForWrongPairingOtherThan(numberToAvoid: Int) -> Int {
        let randomNumber = Int(arc4random_uniform(UInt32(wordListDataArray.count)))
        if randomNumber == numberToAvoid {
            return Int(arc4random_uniform(UInt32(wordListDataArray.count)))
        } else {
            return randomNumber
        }

    }
    
    func randomPercent() -> Double {
      return Double(arc4random() % 1000) / 10.0;
    }
    
    func makeRandomNumberList(_ numberOfPairings: Int) -> [Int] {
        return (0..<numberOfPairings).map{ _ in Int.random(in: 0 ... wordListDataArray.count - 1) }
    }
    
    func getCorrectAnswersValue() -> String {
        return "\(self.stateManager.correctChoices)"
    }
    
    func getWrongAnswersValues() -> String {
        return "\(self.stateManager.incorrectChoices)"
    }
    
    func userSelectedWrong() {
        self.countdown?.invalidate()
        if isShowingRightOption {
            self.stateManager.incorrectChoices = self.stateManager.incorrectChoices + 1
        } else {
            self.stateManager.correctChoices = self.stateManager.correctChoices + 1
        }
    }
    
    func userSelectedCorrect() {
        self.countdown?.invalidate()
        if isShowingRightOption {
            self.stateManager.correctChoices = self.stateManager.correctChoices + 1
        } else {
            self.stateManager.incorrectChoices = self.stateManager.incorrectChoices + 1
        }
    }
    
    func getEnglishWordToDisplay() -> String {
        return self.englishWordToDisplay
    }
    
    func getSpanishWordToDisplay() -> String {
        return self.spanishWordToDisplay
    }
    
    func getTimeForAttempt() -> Int {
        return self.provider.getTimeAllowedForAttempt()
    }
    
}
