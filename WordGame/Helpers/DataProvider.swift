//
//  DataProvider.swift
//  WordGame
//
//  Created by XiSYS Creatives on 14/05/2022.
//

import Foundation

protocol DataProviderProtocol {
    func fetchAndProvideWordList(completion: @escaping (_ wordList: [[String: String]]?) -> Void)
    func getIncorrectAttemptsAllowed() -> Int
    func getTimeAllowedForAttempt() -> Int
    func getNumberOfPairingsToShow() -> Int
}

class DataProvider: DataProviderProtocol {
    
    func fetchAndProvideWordList(completion: @escaping (_ wordList: [[String: String]]?) -> Void) {
        if let path = Bundle.main.path(forResource: "words", ofType: "json") {
                  do {
                      let fileUrl = URL(fileURLWithPath: path)
                      let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                      let json = try JSONSerialization.jsonObject(with: data, options: [])
                      if let object = json as? [[String: String]]{
                          completion(object)
                      } else {
                          completion([])
                      }
                      
                  } catch {
                      // Handle error here
                      print("error parsing local json...")
                      completion(nil)
                  }
              }
    }
   
    func getIncorrectAttemptsAllowed() -> Int {
        return 3
    }
    
    func getTimeAllowedForAttempt() -> Int {
        return 5
    }
    
    func getNumberOfPairingsToShow() -> Int {
        return 15
    }
}

