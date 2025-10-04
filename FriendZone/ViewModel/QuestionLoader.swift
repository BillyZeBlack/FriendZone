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
	
	private func selectedTenRandomQuestion(questionsSelected: [Question], ageRange: Int, isPremium: Bool = false)
	{
		// Filtrer les questions selon l'âge et le statut premium
		var filteredQuestions = questionsSelected
			.filter { $0.ageRangeQuestion.contains(ageRange) }
		
		// Si l'utilisateur n'est pas premium, exclure les questions premium
		if !isPremium {
			filteredQuestions = filteredQuestions.filter { !$0.isPremium }
			print("📋 \(filteredQuestions.count) questions gratuites disponibles pour l'âge \(ageRange)")
		} else {
			print("📋 \(filteredQuestions.count) questions totales disponibles pour l'âge \(ageRange) (Premium activé)")
		}
		
		// Sélection équilibrée par thème : 2 questions par thème (5 thèmes × 2 = 10 questions)
		self.questionsSelected = selectBalancedQuestions(questions: filteredQuestions, targetCount: 10)
	}
	
	private func selectBalancedQuestions(questions: [Question], targetCount: Int) -> [Question] {
		let themes = ["Communication", "Intimité", "Attention", "Projet", "Affection"]
		var selectedQuestions: [Question] = []
		
		// Grouper les questions par thème et mélanger
		var questionsByTheme: [String: [Question]] = [:]
		for theme in themes {
			let themeQuestions = questions.filter { $0.questionTheme == theme }
			questionsByTheme[theme] = themeQuestions.shuffled()
		}
		
		// Sélectionner 2 questions uniques par thème
		for theme in themes {
			if let themeQuestions = questionsByTheme[theme] {
				// Prendre les 2 premières questions uniques de ce thème
				let questionsToAdd = Array(themeQuestions.prefix(2))
				selectedQuestions.append(contentsOf: questionsToAdd)
			}
		}
		
		// Si on n'a pas assez de questions (certains thèmes n'ont pas assez de questions)
		if selectedQuestions.count < targetCount {
			let remainingNeeded = targetCount - selectedQuestions.count
			// Prendre des questions des thèmes qui en ont le plus
			let selectedIds = Set(selectedQuestions.map { $0.id })
			let availableQuestions = questions.filter { !selectedIds.contains($0.id) }
			selectedQuestions.append(contentsOf: availableQuestions.shuffled().prefix(remainingNeeded))
		}
		
		// Mélanger final pour éviter l'effet "bloc"
		let finalSelection = Array(selectedQuestions.shuffled().prefix(targetCount))
		
		print("📊 Sélection finale: \(finalSelection.count) questions")
		print("🎨 Répartition par thème:")
		for theme in themes {
			let count = finalSelection.filter { $0.questionTheme == theme }.count
			print("   \(theme): \(count) questions")
		}
		
		return finalSelection
	}
	
	func loadQuestionsList(ageRange: Int, isPremium: Bool = false)
	{
		questionsSelected = []
		selectedTenRandomQuestion(questionsSelected: questions, ageRange: ageRange, isPremium: isPremium)
		print("📊 \(questionsSelected.count) questions sélectionnées pour l'âge \(ageRange) (Premium: \(isPremium))")
	}
}
