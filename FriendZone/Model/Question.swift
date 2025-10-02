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
}
