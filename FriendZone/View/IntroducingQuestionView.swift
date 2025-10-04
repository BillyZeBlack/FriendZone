//
//  IntroducingQuestionView.swift
//  FriendZone
//
//  Created by williams saadi on 24/10/2024.
//

import SwiftUI

struct IntroducingQuestionView: View {
    @EnvironmentObject var formData: FormData
    @EnvironmentObject var questionLoader: QuestionLoader
    @EnvironmentObject var resultLoader: ResultLoader
    @EnvironmentObject var premiumManager: PremiumManager
    
    @State var ageRange: Int = 1
    @State var partnerAgeRange: Int = 1
    @State var gender : Bool = false
    @State var durationOfRelationship: Int = 1
    @State var genderPartner: Bool = false
    @State var navigateToNextView: Bool = false
    
    let blockSpacing: CGFloat = 20 //32 si premium activé
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: blockSpacing) {
                    // Header avec titre et illustration
                    VStack(spacing: 16) {
                        Image(systemName: "heart.text.square.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(
                                .linearGradient(
                                    colors: [.pink, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text("Faisons connaissance")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                        
                        Text("Quelques informations pour personnaliser ton expérience")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 40)
                    
                    // Carte d'informations principales
                    VStack(spacing: 24) {
                        // Section Genre du crush
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.blue)
                                    .font(.headline)
                                
                                Text("Ton crush")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                            
                            HStack {
                                Text("Mon crush est \(genderPartner ? "un" : "une")")
                                    .font(.body)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                // Toggle stylisé
                                HStack(spacing: 12) {
                                    Text("fille")
                                        .font(.subheadline)
                                        .foregroundColor(genderPartner ? .secondary : .primary)
                                        .fontWeight(genderPartner ? .regular : .semibold)
                                    
                                    ZStack {
                                        Capsule()
                                            .fill(genderPartner ? .blue : .gray.opacity(0.3))
                                            .frame(width: 52, height: 32)
                                        
                                        Circle()
                                            .fill(.white)
                                            .frame(width: 26, height: 26)
                                            .offset(x: genderPartner ? 10 : -10)
                                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    }
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            genderPartner.toggle()
                                        }
                                    }
                                    
                                    Text("garçon")
                                        .font(.subheadline)
                                        .foregroundColor(genderPartner ? .primary : .secondary)
                                        .fontWeight(genderPartner ? .semibold : .regular)
                                }
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemBackground))
                                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                        )
                        
                        // Section Âge
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.orange)
                                    .font(.headline)
                                
                                Text("Ton âge")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                            
                            VStack(spacing: 12) {
                                ForEach(1...3, id: \.self) { index in
                                    HStack {
                                        Image(systemName: ageRange == index ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(ageRange == index ? .blue : .secondary)
                                            .font(.body)
                                        
                                        Text(getAgeRangeText(for: index))
                                            .font(.body)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                    }
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(ageRange == index ? Color.blue.opacity(0.1) : Color.clear)
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3)) {
                                            ageRange = index
                                        }
                                    }
                                }
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemBackground))
                                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Bouton de validation
                    Button(action: {
                        formDataResponses()
                        loadQuestionsList()
                        navigateToNextView = true
                    }) {
                        HStack {
                            Text("Commencer le test")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Image(systemName: "arrow.right")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    .linearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 20)
//                    .padding(2)
                    
                    // Bouton Premium (toujours affiché pour les tests)
                    VStack(spacing: 8) {
                        Button(action: {
                            if premiumManager.isPremiumActive {
                                premiumManager.togglePremium()
                            } else {
                                premiumManager.purchasePremium()
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "crown.fill")
                                    .font(.headline)
                                    .foregroundColor(premiumManager.isPremiumActive ? .green : .yellow)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(premiumManager.isPremiumActive ? "Pack Premium Activé" : "Passer à Premium")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                    
                                    Text(premiumManager.isPremiumActive ? "Cliquez pour désactiver" : "Accès à toutes les questions")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
//                                Image(systemName: premiumManager.isPremiumActive ? "checkmark.circle.fill" : "chevron.right")
//                                    .font(.caption)
//                                    .foregroundColor(premiumManager.isPremiumActive ? .green : .secondary)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                            )
                        }
                        
                        // Indicateur d'état premium
                        HStack {
                            Image(systemName: premiumManager.isPremiumActive ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(premiumManager.isPremiumActive ? .green : .secondary)
                                .font(.caption)
                            
                            Text(premiumManager.isPremiumActive ? "Premium Activé" : "Premium Désactivé")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(8)
                    }
                    .padding(.horizontal, 20)
//                    .padding(.top, 8)
                    
//                    Spacer(minLength: 20)

                }
            }
            .background(
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
            )
            .navigationDestination(isPresented: $navigateToNextView) {
                ContentView()
                    .environmentObject(formData)
                    .environmentObject(questionLoader)
                    .environmentObject(resultLoader)
                    .toolbarRole(.editor)
            }
        }
    }
    
    private func getAgeRangeText(for index: Int) -> String {
        switch index {
        case 1:
            return "10 - 13 ans"
        case 2:
            return "13 - 15 ans"
        case 3:
            return "Plus de 15 ans"
        default:
            return "10 - 13 ans"
        }
    }
    
    private func formDataResponses()
    {
        formData.formDataResponses(ageRange: ageRange, partenerAgeRange: partnerAgeRange, gender: gender, partnerGender: genderPartner , durationOfRelationShip: durationOfRelationship)
    }
    
    private func loadQuestionsList()
    {
        questionLoader.loadQuestionsList(ageRange: formData.ageRange, isPremium: premiumManager.isPremiumActive)
    }
}

#Preview {
    IntroducingQuestionView()
}

