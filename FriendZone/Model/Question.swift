//
//  Question.swift
//  FriendZone
//
//  Created by williams saadi on 23/10/2024.
//

import Foundation

struct Question: Identifiable, Decodable{
	var id: Int
	var question: String
	var responses: [Response]
	var ageRangeQuestion: [Int]
    var isPremium: Bool
	
	enum CodingKeys: String, CodingKey {
		case id
		case question
		case responses
		case ageRangeQuestion
		case isPremium
	}
}
