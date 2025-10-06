//
//  CardChartView.swift
//  FriendZone
//
//  Created by williams saadi on 27/11/2024.
//

import SwiftUI
import Charts

struct CardChartView: View {
    @EnvironmentObject var contentVM: ContentViewModel
    
	var dataScore : [DataScore]
	var isFlipped: Bool
	var isTrue: CGFloat
	var isFalse: CGFloat
	var scoreResult: Int
	
    var body: some View {
		VStack(spacing: 20) {			
			// Carte principale avec graphique
			ZStack {
				// Fond avec effet de profondeur
				RoundedRectangle(cornerRadius: 24)
					.frame(width: 340, height: 480)
					.foregroundStyle(
						.linearGradient(
							colors: [Color(.systemGray6), Color(.systemGray5)],
							startPoint: .topLeading,
							endPoint: .bottomTrailing
						)
					)
					.shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
				
				// Bordure subtile
				RoundedRectangle(cornerRadius: 24)
					.stroke(Color.primary.opacity(0.1), lineWidth: 1)
					.frame(width: 340, height: 480)
				
				VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        Text("Analyse de tes réponses")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
					// Graphique amélioré
					Chart{
						ForEach(dataScore, id: \.id) { ds in
							BarMark(
								x: .value("Catégorie", ds.scoreLabel),
								y: .value("Réponses", ds.score)
							)
							.foregroundStyle(by: .value("Catégorie", ds.scoreLabel))
							.cornerRadius(8)
							.annotation(position: .top) {
								Text("\(ds.score)")
									.font(.caption)
									.fontWeight(.medium)
									.foregroundColor(.primary)
							}
						}
					}
					.chartForegroundStyleScale([
						"Tu peux y aller !": .green,
						"Dans le doute...": .orange,
						"Lache l'affaire !": .red
					])
					.chartYAxis {
						AxisMarks(position: .leading) { value in
							AxisGridLine()
							AxisTick()
							AxisValueLabel {
								if let intValue = value.as(Int.self) {
									Text("\(intValue)")
										.font(.caption)
										.foregroundColor(.secondary)
								}
							}
						}
					}
					.chartXAxis {
						AxisMarks(preset: .aligned, position: .bottom) { value in
							AxisValueLabel {
								if let stringValue = value.as(String.self) {
									Text(stringValue)
										.font(.caption)
										.fontWeight(.medium)
										.foregroundColor(.primary)
										.multilineTextAlignment(.center)
								}
							}
						}
					}
					.frame(width: 300, height: 300)
					
					// Légende améliorée
					VStack(alignment: .leading, spacing: 12) {
						ForEach(dataScore, id: \.id) { ds in
							HStack {
								Circle()
									.fill(getColorForCategory(ds.scoreLabel))
									.frame(width: 12, height: 12)
								
								Text(ds.scoreLabel)
									.font(.subheadline)
									.foregroundColor(.primary)
								
								Spacer()
								
                                if(ds.score <= 1){
                                    Text("\(ds.score) point")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                } else {
                                    Text("\(ds.score) points")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
							}
						}
                        // Instructions
                        Text("Touche l'écran pour voir le commentaire")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
					}
					.padding(.horizontal, 20)
				}
				.padding(.vertical, 20)
			}
			
            // Bannière conditionnelle (uniquement si pas premium)
            if !contentVM.hasPremiumPack {
                VStack {
                    // TODO: : A remplacer avec le bon ID de banniere : ca-app-pub-8777271534976494/7963981117
                    AdBannerView(adUnitID: "ca-app-pub-3940256099942544/2934735716")
                        .frame(height: 50)
                }
                .padding()
            }
		}
		.padding(.horizontal, 20)
		.rotation3DEffect(
			.degrees(isFlipped ? isTrue : isFalse),
			axis: (x: 0.0, y: 1.0, z: 0.0)
		)
    }
	
	private func getColorForCategory(_ category: String) -> Color {
		switch category {
		case "Tu peux y aller !":
			return .green
		case "Dans le doute...":
			return .orange
		case "Lache l'affaire !":
			return .red
		default:
			return .blue
		}
	}
}

//#Preview {
//	CardChartView(dataScore: <#[DataScore]#>)
//}
