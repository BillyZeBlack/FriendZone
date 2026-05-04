//
//  CommentLoader.swift
//  FriendZone
//
//  Created by williams saadi on 20/11/2024.
//

import Foundation

class ResultLoader: ObservableObject {
	
	@Published var comment: String = ""
	@Published var score: Int = 0
	@Published var letsGoScore: Int = 0
	@Published var middleScore: Int = 0
	@Published var friendzoneScore: Int = 0
	@Published var dataScore: [DataScore] = []
	@Published var zoneScore: String = ""
	
	var results :[Result] = []
	
	init() {
		loadResults()
	}
	
	private func loadResults()
	{
		if let url = Bundle.main.url(forResource: "result", withExtension: "json") {
			do {
				let data = try Data(contentsOf: url)
				let response = try JSONDecoder().decode(CommentResponse.self, from: data)
				
				results = response.results
				
			} catch {
			}
		}
	}
	
	func getCommentResult(ageRange: Int) -> String
	{
		let ageRangesMap = [
			1: "13-15",
			2: "15-17",
			3: "17 plus"
		]
		
		let ageRangeString = ageRangesMap[ageRange] ?? "13-15"
		
		// Déterminer la zone basée sur la catégorie avec le plus de réponses
		let categoryScores = [
			"letsGo": letsGoScore,
			"middle": middleScore,
			"friendzone": friendzoneScore
		]
		
		zoneScore = categoryScores.max(by: { $0.value < $1.value })?.key ?? "friendzone"
		
        dataScore = [
            DataScore(
                scoreLabel: "Tu peux y aller !", score: letsGoScore
            ),
            DataScore(
                scoreLabel: "Dans le doute...", score: middleScore
            ),
            DataScore(
                scoreLabel: "Lache l'affaire !", score: friendzoneScore
            )
        ]
		
		if let result = results.first(where: { $0.status == zoneScore }),
		   let ageGroup = result.ageRanges.first(where: { $0.rangeDescription == ageRangeString }),
		   let comment = ageGroup.comments.randomElement() {
			return comment
		}
		
		return "Aucun commentaire disponible"
	}
	
	func resestData() {
		score = 0
		letsGoScore = 0
		middleScore = 0
		friendzoneScore = 0
	}
}
