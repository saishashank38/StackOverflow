//
//  Question.swift
//  StackOverflow
//
//  Created by sai on 31/01/20.
//  Copyright © 2020 sai. All rights reserved.
//

import Foundation

/// Model for holding Question details
struct Question: Codable {
    let title: String
    let isAnswered: Bool
    let answerCount: Int
    let acceptedAnswerId: Int?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case isAnswered = "is_answered"
        case answerCount = "answer_count"
        case acceptedAnswerId = "accepted_answer_id"
    }
}
