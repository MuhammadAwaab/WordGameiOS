//
//  WordGameTests.swift
//  WordGameTests
//
//  Created by XiSYS Creatives on 14/05/2022.
//

import XCTest
@testable import WordGame

class WordGameTests: XCTestCase {

    var viewModelToTest: GameViewModelProtocol?
    var secondSettingViewModel: GameViewModelProtocol?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        try testWithFirstMockSettings()
        try testWithSecondMockSettings()
    }

    func testWithFirstMockSettings() throws {
        viewModelToTest = GameViewModel(provider: firstMockProvider())
        
        XCTAssertTrue(viewModelToTest?.getTimeForAttempt() == 1)
        XCTAssertTrue(viewModelToTest?.getEnglishWordToDisplay() == "")
        XCTAssertTrue(viewModelToTest?.getSpanishWordToDisplay() == "")
        XCTAssertTrue(viewModelToTest?.getWrongAnswersValues() == "0" || viewModelToTest?.getWrongAnswersValues() == "")
        XCTAssertTrue(viewModelToTest?.getCorrectAnswersValue() == "0" || viewModelToTest?.getCorrectAnswersValue() == "")
        
        viewModelToTest?.startGame()
        
        let exp = expectation(description: "Game should be over after 5 seconds")
         let result = XCTWaiter.wait(for: [exp], timeout: 5.0)
         if result == XCTWaiter.Result.timedOut {
            // XCTAssert(<test if state is correct after this delay>)
             XCTAssertTrue(viewModelToTest?.getWrongAnswersValues() == "4")
             XCTAssertTrue(viewModelToTest?.getCorrectAnswersValue() == "0")
             XCTAssertFalse(viewModelToTest?.getEnglishWordToDisplay() == "")
             XCTAssertFalse(viewModelToTest?.getSpanishWordToDisplay() == "")

         } else {
             XCTFail("Delay interrupted")
         }

    }
    
    func testWithSecondMockSettings() throws {
        secondSettingViewModel = GameViewModel(provider: secondMockProvider())
        
        XCTAssertTrue(secondSettingViewModel?.getTimeForAttempt() == 20)
        XCTAssertTrue(secondSettingViewModel?.getEnglishWordToDisplay() == "")
        XCTAssertTrue(secondSettingViewModel?.getSpanishWordToDisplay() == "")
        XCTAssertTrue(secondSettingViewModel?.getWrongAnswersValues() == "0" || secondSettingViewModel?.getWrongAnswersValues() == "")
        XCTAssertTrue(secondSettingViewModel?.getCorrectAnswersValue() == "0" || secondSettingViewModel?.getCorrectAnswersValue() == "")
        
        secondSettingViewModel?.startGame()
        
        let timeInSeconds = 1.0
        let expectation = XCTestExpectation(description: "Two selections made")

        DispatchQueue.main.asyncAfter(deadline: .now() + timeInSeconds) {
            self.secondSettingViewModel?.userSelectedWrong()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + (timeInSeconds * 5)) {
            self.secondSettingViewModel?.userSelectedCorrect()
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeInSeconds + 10.0)
        
        XCTAssertFalse(secondSettingViewModel?.getEnglishWordToDisplay() == "")
        XCTAssertFalse(secondSettingViewModel?.getSpanishWordToDisplay() == "")
        
        let correctValue = Int(secondSettingViewModel?.getCorrectAnswersValue() ?? "0")
        let wrongValue = Int(secondSettingViewModel?.getWrongAnswersValues() ?? "0")
        
        XCTAssertTrue((correctValue! + wrongValue!) == 2)
        
        secondSettingViewModel?.restartGame()
        XCTAssertTrue(secondSettingViewModel?.getWrongAnswersValues() == "0")
        XCTAssertTrue(secondSettingViewModel?.getCorrectAnswersValue() == "0")

    }
    
    override func setUp() {
            super.setUp()
        }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
