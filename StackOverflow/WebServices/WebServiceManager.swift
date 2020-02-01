//
//  WebServiceManager.swift
//  StackOverflow
//
//  Created by sai on 31/01/20.
//  Copyright © 2020 sai. All rights reserved.
//

import Foundation


/// Class that performs web service calls, checks associated with network, parsing etc
class WebServiceManager {
    /// Singleton object to access the object
    static let manager = WebServiceManager()
    let session = URLSession(configuration: .default)
    var reachability: Reachability?
    
    /// inititalize the variables here
    private init() {
        do {
            reachability = try Reachability()
        } catch {
            print("Error in handling reachability")
        }
    }
    
    /// Method to fetch stack overflow questions by placing webservice call
    /// - Parameter completionHandler: Closure that returns either set of questions received or error is returned
    func fetchQuestions(completionHandler:@escaping ([Question]?, Error?) -> Void) {
        if reachability?.connection != .unavailable {
            let url = Constants.api + Constants.apiKey
            session.dataTask(with: URL(string: url)!) { (receivedData, _, error) in
                if error != nil {
                    completionHandler(nil, error)
                } else {
                    if let rData = receivedData {
                        do {
                            let decoder = JSONDecoder()
                            let items = try decoder.decode(Items.self, from: rData)
                            print("Received: \(items.items.count)")
                            completionHandler(items.items.filter { question in
                                return question.isAnswered == true && question.answerCount > 1
                            }, nil)
                        } catch {
                            print(error)
                            completionHandler(nil, NSError(domain: "com.coding.sample", code: 1001, userInfo: ["description": "Error in parsing data"]) as Error)
                        }
                    }
                }
            }.resume()
        } else {
            completionHandler(nil, NSError(domain: "com.coding.sample", code: 1002, userInfo: ["description": "No network"]) as Error)
        }
    }
}
