//
//  IntroductiongQuestionsData.swift
//  FriendZone
//
//  Created by williams saadi on 25/10/2024.
//

import Foundation

class FormData: ObservableObject {
	@Published var formResponses: [String: Any] = [:]
	
	var ageRange: Int = 1
	var partnerAgeRange : Int = 1
	var gender: Bool = false
	var partnerGender : Bool = false
	var durationOfRelationship : Int = 1
	
	func formDataResponses(ageRange: Int, partenerAgeRange: Int, gender: Bool, partnerGender: Bool, durationOfRelationShip: Int)
	{
		self.ageRange = ageRange
		self.partnerGender = partnerGender
		self.gender = gender
		self.partnerAgeRange = partenerAgeRange
		self.durationOfRelationship = durationOfRelationShip
	}
	
}
