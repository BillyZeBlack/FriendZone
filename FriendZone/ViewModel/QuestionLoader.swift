//
//  QuestionLoader.swift
//  FriendZone
//
//  Created by williams saadi on 23/10/2024.
//

import Foundation

class QuestionLoader: ObservableObject {
	
	@Published var questionsSelected : [Question] = []
	
	var questions : [Question] = []
	
	init(){
		self.loadQuestion()
	}
	
	private func loadQuestion()
	{
		guard let url = Bundle.main.url(forResource: "question", withExtension: "json") else {
			print("Erreur : le fichier JSON est introuvable.")
			return
		}
		
		do {
			let data = try Data(contentsOf: url)
			
			let decoder = JSONDecoder()
			
			let questionsList = try decoder.decode(QuestionList.self, from: data)
			questions = questionsList.questions
			print("✅ \(questions.count) questions chargées avec succès")
		}
		catch {
			print("❌ Erreur lors du chargement du fichier JSON : \(error)")
		}
	}
	
	private func selectedTenRandomQuestion(questionsSelected: [Question], ageRange: Int)
	{
		let filteredQuestions = questionsSelected
			.filter { $0.ageRangeQuestion.contains(ageRange) }
		
		print("📋 \(filteredQuestions.count) questions disponibles pour l'âge \(ageRange)")
		
		self.questionsSelected = Array(filteredQuestions
			.shuffled()
			.prefix(10))
	}
	
	func loadQuestionsList(ageRange: Int)
	{
		questionsSelected = []
		selectedTenRandomQuestion(questionsSelected: questions, ageRange: ageRange)
		print("📊 \(questionsSelected.count) questions sélectionnées pour l'âge \(ageRange)")
	}
}
