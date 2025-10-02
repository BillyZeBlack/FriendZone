//
//  ContentView.swift
//  FriendZone
//
//  Created by williams saadi on 23/10/2024.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var formData: FormData
	@EnvironmentObject var questionLoader: QuestionLoader
	@EnvironmentObject var resultLoader: ResultLoader
	
	@State var contentVM = ContentViewModel()
	//var questions : [Question] = []
	
	@State var i = 0
	@State private var progress = 1.0
	@State var isVisible: Bool = false
	@State var questionLetter: [String] = ["A", "B", "C", "D"]
	
	var body: some View {
		VStack(spacing: 0) {
			if(i < questionLoader.questionsSelected.count){
				// Header avec progression
				VStack(spacing: 16) {
					// Barre de progression stylisée
					VStack(spacing: 8) {
						HStack {
							Text("Question \(i + 1)/10")
								.font(.headline)
								.fontWeight(.semibold)
								.foregroundColor(.primary)
							
							Spacer()
							
							Text("\(Int(((progress / 10)*100)))%")
								.font(.subheadline)
								.fontWeight(.medium)
								.foregroundColor(.secondary)
						}
						
						ZStack(alignment: .leading) {
							Capsule()
								.fill(Color(.systemGray5))
								.frame(height: 8)
							
							Capsule()
								.fill(
									.linearGradient(
										colors: [.blue, .purple],
										startPoint: .leading,
										endPoint: .trailing
									)
								)
								.frame(width: CGFloat(progress / 10.0) * (UIScreen.main.bounds.width - 80), height: 8)
								.shadow(color: .blue.opacity(0.3), radius: 2, x: 0, y: 1)
						}
					}
					.padding(.horizontal, 20)
					.padding(.top, 20)
					
					// Question actuelle
					VStack(spacing: 12) {
						HStack {
							Image(systemName: "questionmark.circle.fill")
								.foregroundColor(.blue)
								.font(.title3)
							
							Text("Question \(i + 1)")
								.font(.title3)
								.fontWeight(.bold)
								.foregroundColor(.primary)
							
							Spacer()
						}
						
						Text(adaptPronom(response: questionLoader.questionsSelected[i].question, genre: formData.partnerGender))
							.font(.body)
							.foregroundColor(.primary)
							.multilineTextAlignment(.leading)
							.lineSpacing(4)
							.frame(maxWidth: .infinity, alignment: .leading)
					}
					.padding(20)
					.background(
						RoundedRectangle(cornerRadius: 16)
							.fill(Color(.systemBackground))
							.shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
					)
					.padding(.horizontal, 20)
				}
				
				// Liste des réponses améliorée
				ScrollView {
					LazyVStack(spacing: 12) {
						ForEach(Array(questionLoader.questionsSelected[i].responses.shuffled().enumerated()), id: \.element.response) { index, rep in
							HStack(spacing: 16) {
								// Indicateur de lettre stylisé
								ZStack {
									Circle()
										.fill(
											.linearGradient(
												colors: getGradientColors(for: index),
												startPoint: .topLeading,
												endPoint: .bottomTrailing
											)
										)
										.frame(width: 44, height: 44)
										.shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
									
									Text(questionLetter[index])
										.font(.headline)
										.fontWeight(.bold)
										.foregroundColor(.white)
								}
								
								// Texte de la réponse
								Text(adaptPronom(response: rep.response, genre: formData.partnerGender))
									.font(.body)
									.foregroundColor(.primary)
									.multilineTextAlignment(.leading)
									.lineSpacing(4)
								
								Spacer()
								
								// Indicateur de sélection
								Image(systemName: "chevron.right")
									.font(.subheadline)
									.foregroundColor(.secondary)
							}
							.padding(16)
							.background(
								RoundedRectangle(cornerRadius: 16)
									.fill(Color(.systemBackground))
									.shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
							)
							.onTapGesture {
								withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
									i += 1
									progress += 1
									addScores(score: rep.score)
								}
							}
							.padding(.horizontal, 20)
						}
					}
					.padding(.top, 20)
					.padding(.bottom, 20)
				}
				.background(Color(.systemGroupedBackground))
				
			} else {
				ResultView()
					.environmentObject(formData)
					.environmentObject(resultLoader)
					.toolbarRole(.editor)
			}
		}
		.background(Color(.systemGroupedBackground).ignoresSafeArea())
		.onAppear{
			isVisible = false
			i = 0
			questionLoader.loadQuestionsList(ageRange: formData.ageRange)
		}
	}
	
	private func getGradientColors(for index: Int) -> [Color] {
		switch index {
		case 0:
			return [.blue, .purple]
		case 1:
			return [.green, .teal]
		case 2:
			return [.orange, .red]
		case 3:
			return [.pink, .purple]
		default:
			return [.blue, .purple]
		}
	}
	
	private func addScores(score: Int)
	{
		resultLoader.score += score
		
		switch score {
		case 0...1:
			resultLoader.letsGoScore += 1
		case 2:
			resultLoader.middleScore += 1
		case 3:
			resultLoader.friendzoneScore += 1
		default:
			break
		}
	}
	
	private func resetData()
	{
		i = 0
		progress = 1.0
		questionLoader.loadQuestionsList(ageRange: formData.ageRange)
	}
	
	private func adaptPronom(response: String, genre: Bool) ->String
	{
		return contentVM.adaptPronom(response: response, genre: genre)
	}
}

#Preview {
	ContentView()
}
