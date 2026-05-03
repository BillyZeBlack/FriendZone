//
//  CardView.swift
//  FriendZone
//
//  Created by williams saadi on 13/11/2024.
//

import SwiftUI

struct CardView: View {
    @EnvironmentObject var contentVM: ContentViewModel
    
	var textContent: String
	var textColor: Color
	var backgroundColor: Color
	var scolor: Color
	var isTrue: CGFloat
	var isFalse: CGFloat
	var isFlipped: Bool
	var zoneScore: String
	
	var body: some View {
		VStack(spacing: 20) {
			// Carte principale
			ZStack {
				// Fond principal avec effet de profondeur
				RoundedRectangle(cornerRadius: 24)
					.frame(width: 340, height: 520)
					.foregroundStyle(
						.linearGradient(
							colors: [Color(.systemBackground), Color(.systemGray6)],
							startPoint: .topLeading,
							endPoint: .bottomTrailing
						)
					)
					.shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
				
				// Accent color stylisé
				RoundedRectangle(cornerRadius: 24)
					.trim(from: 0, to: 0.25)
					.rotation(.degrees(45))
					.frame(width: 280, height: 280)
					.foregroundStyle(
						.linearGradient(
							colors: [getAccentColor(for: zoneScore), getAccentColor(for: zoneScore).opacity(0.7)],
							startPoint: .topLeading,
							endPoint: .bottomTrailing
						)
					)
					.offset(x: 80, y: -120)
					.blur(radius: 20)
					.opacity(0.3)
				
				// Contenu principal - centré verticalement
				VStack(spacing: 24) {
					Spacer()
					
					// Header avec résultat
					VStack(spacing: 12) {
						Image(systemName: getResultIcon(for: zoneScore))
							.font(.system(size: 48))
							.foregroundStyle(
								.linearGradient(
									colors: [getAccentColor(for: zoneScore), getAccentColor(for: zoneScore).opacity(0.7)],
									startPoint: .topLeading,
									endPoint: .bottomTrailing
								)
							)
						
						Text(getZoneScore(zoneScore: zoneScore))
							.font(.title2)
							.fontWeight(.bold)
							.foregroundColor(getAccentColor(for: zoneScore))
							.multilineTextAlignment(.center)
					}
					
					// Contenu du commentaire
					VStack(spacing: 16) {
						Text("Analyse personnalisée")
							.font(.headline)
							.fontWeight(.semibold)
							.foregroundColor(.primary)
							.frame(maxWidth: .infinity, alignment: .leading)
						
						ScrollView {
							Text(textContent)
								.font(.body)
								.foregroundColor(.primary)
								.multilineTextAlignment(.leading)
								.lineSpacing(6)
								.padding(.horizontal, 4)
						}
						.frame(height: 240)
						.scrollIndicators(.visible)
					}
					.padding(.horizontal, 20)
					
					Spacer()
					
					// Instructions
					Text("Touche l'écran pour voir les statistiques")
						.font(.caption)
						.foregroundColor(.secondary)
						.padding(.bottom, 20)
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
			.frame(width: 340, height: 520)
			.rotation3DEffect(
				.degrees(isFlipped ? isTrue : isFalse),
				axis: (x: 0.0, y: 1.0, z: 0.0)
			)
			
			// Bannière conditionnelle (uniquement si pas premium)
			if !contentVM.hasPremiumPack {
				VStack {
					AdBannerView(adUnitID: "ca-app-pub-8777271534976494/7963981117")
						.frame(height: 50)
				}
				.padding(.horizontal)
			}
		}
	}
	
	private func getZoneScore(zoneScore: String) -> String {
		switch zoneScore {
		case "friendzone":
			return "Lâche l'affaire !"
		case "middle":
			return "Dans le doute..."
		case "letsGo":
			return "Tu peux y aller !"
		default:
			return "Dans le doute..."
		}
	}
	
	private func getAccentColor(for zoneScore: String) -> Color {
		switch zoneScore {
		case "friendzone":
			return .red
		case "middle":
			return .orange
		case "letsGo":
			return .green
		default:
			return .blue
		}
	}
	
	private func getResultIcon(for zoneScore: String) -> String {
		switch zoneScore {
		case "friendzone":
			return "xmark.circle.fill"
		case "middle":
			return "questionmark.circle.fill"
		case "letsGo":
			return "checkmark.circle.fill"
		default:
			return "questionmark.circle.fill"
		}
	}
}

#Preview {
	CardView(textContent: "Ceci est un exemple de commentaire personnalisé basé sur tes réponses au questionnaire. Ton analyse montre que tu as répondu de manière équilibrée aux différentes questions, ce qui indique une situation où il faut prendre le temps de réfléchir avant de prendre une décision.", textColor: .black, backgroundColor: .gray, scolor: .orange, isTrue: 1, isFalse: 0, isFlipped: false, zoneScore: "middle")
}
