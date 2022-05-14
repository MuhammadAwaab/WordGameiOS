//
//  MockDataProvider.swift
//  WordGame
//
//  Created by XiSYS Creatives on 14/05/2022.
//

import Foundation


class firstMockProvider: DataProviderProtocol {
    func fetchAndProvideWordList(completion: @escaping ([[String : String]]?) -> Void) {
        if let path = Bundle.main.path(forResource: "sampleJson", ofType: "json") {
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
        4
    }
    
    func getTimeAllowedForAttempt() -> Int {
        1
    }
    
    func getNumberOfPairingsToShow() -> Int {
        4
    }
    
}


class secondMockProvider: DataProviderProtocol {
    func fetchAndProvideWordList(completion: @escaping ([[String : String]]?) -> Void) {
        if let path = Bundle.main.path(forResource: "sampleJson", ofType: "json") {
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
        4
    }
    
    func getTimeAllowedForAttempt() -> Int {
        20
    }
    
    func getNumberOfPairingsToShow() -> Int {
        4
    }
    
}
