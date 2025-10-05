//
//  ResultView.swift
//  FriendZone
//
//  Created by williams saadi on 25/10/2024.
//

import SwiftUI
import Charts

struct ResultView: View {
	@EnvironmentObject var formData: FormData
	@EnvironmentObject var resultLoader: ResultLoader
	@EnvironmentObject var contentVM: ContentViewModel
	
	@State var isFlipped: Bool = false
	@State var comment: String = ""
	@State var showInterstitialAd = false
	@State var hasShownAdForRetest = false
	@Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            if comment.isEmpty {
                Text("Chargement des résultats...")
                    .font(.title)
                    .foregroundColor(.gray)
            } else {
                ZStack {
                    CardView(textContent: comment, textColor: .white, backgroundColor: .gray.opacity(0.5), scolor: .pink, isTrue: 0, isFalse: -90, isFlipped: isFlipped, zoneScore: resultLoader.zoneScore)
                        .animation(isFlipped ? .linear.delay(0.35) : .linear, value: isFlipped)
                        .opacity(isFlipped ? 1 : 0)
                    
                    CardChartView(dataScore: resultLoader.dataScore, isFlipped: isFlipped, isTrue: 90, isFalse: 0, scoreResult: resultLoader.score)
                        .animation(isFlipped ? .linear : .linear.delay(0.35), value: isFlipped)
                        .opacity(isFlipped ? 0 : 1)
                }.onTapGesture {
                    withAnimation(.easeIn) {
                        isFlipped.toggle()
                    }
                }
            }
        }
        .onAppear{
            print("ResultView onAppear - Score: \(resultLoader.score), Zone: \(resultLoader.zoneScore)")
            getCommentResult(ageRange: formData.ageRange)
            print("Comment: \(comment)")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // Afficher la pub quand l'utilisateur veut revenir pour refaire un test
                    // Uniquement si pas premium et si pas déjà affichée
                    if !contentVM.hasPremiumPack && !hasShownAdForRetest {
                        showInterstitialAd = true
                        hasShownAdForRetest = true
                    } else {
                        // Si premium ou pub déjà vue, revenir directement
                        dismiss()
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Retour")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true) // Cacher le bouton natif
        .background(
            Group {
                if !contentVM.hasPremiumPack {
                    AdInterstitialView(
                        adUnitID: "ca-app-pub-3940256099942544/4411468910", // ID de test
                        showAd: $showInterstitialAd,
                        onAdDismissed: {
                            // La pub est fermée, revenir automatiquement en arrière
                            print("✅ Publicité interstitielle fermée - Retour vers le questionnaire")
                            dismiss()
                        }
                    )
                }
            }
        )
    }
    
    private func getCommentResult(ageRange: Int)
    {
        comment = contentVM.adaptPronom(response: resultLoader.getCommentResult(ageRange: formData.ageRange), genre: formData.partnerGender)
    }
    
    private func resetData()
    {
        resultLoader.resestData()
    }
}

#Preview {
    ResultView()
}
