//
//  AnalysisLoaderView.swift
//  FriendZone
//
//  Created by williams saadi on 04/10/2025.
//

import SwiftUI

struct AnalysisLoaderView: View {
    @EnvironmentObject var formData: FormData
    @EnvironmentObject var resultLoader: ResultLoader
    
    @State private var currentStep = 0
    @State private var isAnalyzing = true
    @State private var showResults = false

    
    let analysisSteps = [
        "Analyse des réponses...",
        "Calcul de la compatibilité...",
        "Évaluation des sentiments...",
        "Génération des résultats..."
    ]
    
    // Progression par étape (0%, 25%, 50%, 75%, 100%)
    private var stepProgress: Double {
        switch currentStep {
        case 0: return 0.25
        case 1: return 0.50
        case 2: return 0.75
        case 3: return 1.0
        default: return 1.0
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Spacer()
                
                // Animation principale
                VStack(spacing: 24) {
                    // Animation de cœur battant
                    ZStack {
                        Circle()
                            .fill(
                                .linearGradient(
                                    colors: [.pink.opacity(0.3), .purple.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "heart.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(
                                .linearGradient(
                                    colors: [.pink, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .scaleEffect(isAnalyzing ? 1.1 : 0.9)
                            .animation(
                                .easeInOut(duration: 0.8).repeatForever(autoreverses: true),
                                value: isAnalyzing
                            )
                    }
                    
                    // Texte d'analyse
                    VStack(spacing: 16) {
                        Text("Analyse en cours")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(analysisSteps[currentStep])
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .transition(.opacity)
                    }
                    
                    // Barre de progression
                    VStack(spacing: 12) {
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color(.systemGray5))
                                .frame(height: 8)
                            
                            Capsule()
                                .fill(
                                    .linearGradient(
                                        colors: [.pink, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: CGFloat(stepProgress) * (UIScreen.main.bounds.width - 80), height: 8)
                                .shadow(color: .pink.opacity(0.3), radius: 2, x: 0, y: 1)
                        }
                        
                        HStack {
                            Spacer()
                            
                            Text("\(Int(stepProgress * 100))%")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                                .monospacedDigit() 
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Message d'attente
                VStack(spacing: 8) {
                    Text("Veuillez patienter...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Nous analysons vos réponses avec soin")
                        .font(.caption2)
                        .foregroundColor(.secondary.opacity(0.7))
                }
            }
            .padding(.horizontal, 20)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .onAppear {
                startAnalysis()
            }
            .navigationDestination(isPresented: $showResults) {
                ResultView()
                    .environmentObject(formData)
                    .environmentObject(resultLoader)
                    .toolbarRole(.editor)
            }
        }
    }
    
    private func startAnalysis() {
        // Animation du cœur
        isAnalyzing = true
        
        // Changement des étapes d'analyse
        let stepDuration = 5.0 / Double(analysisSteps.count)
        for step in 0..<analysisSteps.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration * Double(step)) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentStep = step
                }
            }
        }
        
        // Navigation vers les résultats après 5 secondes
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            showResults = true
        }
    }
}

#Preview {
    AnalysisLoaderView()
        .environmentObject(FormData())
        .environmentObject(ResultLoader())
}
