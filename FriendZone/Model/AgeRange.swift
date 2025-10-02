//
//  AgeRange.swift
//  FriendZone
//
//  Created by williams saadi on 25/10/2024.
//

import Foundation

struct AgeRange: Codable, CustomStringConvertible, Equatable {
	let rangeDescription: String
	let comments: [String]
	
	var description: String {
		return "Tranche d'age : \(rangeDescription) - \(comments.count) comments"
	}
	
	static func == (lhs: AgeRange, rhs: AgeRange) -> Bool {
		return lhs.rangeDescription == rhs.rangeDescription &&
		lhs.comments == rhs.comments
	}
	
	func isValid() -> Bool {
		// Implémenter une logique de validation
		return !rangeDescription.isEmpty && !comments.isEmpty
	}
}
