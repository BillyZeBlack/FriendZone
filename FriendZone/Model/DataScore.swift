//
//  DataScore.swift
//  FriendZone
//
//  Created by williams saadi on 27/11/2024.
//

import Foundation

struct DataScore: Identifiable {
	var id = UUID().uuidString
	var scoreLabel: String
	var score: Int
}
