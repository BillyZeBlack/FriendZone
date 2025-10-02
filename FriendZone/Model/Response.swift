//
//  Response.swift
//  FriendZone
//
//  Created by williams saadi on 23/10/2024.
//

import Foundation

struct Response: Codable {
	let response: String
	let score: Int
	
	enum CodingKeys: String, CodingKey {
		case response
		case score
	}
}
