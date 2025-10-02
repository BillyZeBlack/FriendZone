//
//  QuestionList.swift
//  FriendZone
//
//  Created by williams saadi on 23/10/2024.
//

import Foundation

struct QuestionList: Codable {
	let questions: [Question]
	
	func encode(to encoder: any Encoder) throws {
		//
	}
}
