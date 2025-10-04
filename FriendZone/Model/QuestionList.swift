//
//  QuestionList.swift
//  FriendZone
//
//  Created by williams saadi on 23/10/2024.
//

import Foundation

struct QuestionList: Decodable {
	let questions: [Question]
	
	enum CodingKeys: String, CodingKey {
		case questions
	}
}
