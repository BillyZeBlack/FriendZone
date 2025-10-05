//
//  AdInterstitialView.swift
//  FriendZone
//
//  Created by Williams SAADI on 05/10/2025.
//

import SwiftUI
import GoogleMobileAds

struct AdInterstitialView: UIViewControllerRepresentable {
    let adUnitID: String
    @Binding var showAd: Bool
    var onAdDismissed: (() -> Void)? = nil
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController() // Conteneur pour présenter l'interstitielle
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if showAd {
            presentInterstitial(from: uiViewController, coordinator: context.coordinator)
            // Réinitialiser immédiatement pour éviter les présentations multiples
            DispatchQueue.main.async {
                showAd = false
            }
        }
    }
    
    private func presentInterstitial(from controller: UIViewController, coordinator: Coordinator) {
        let request = Request()
        InterstitialAd.load(with: adUnitID, request: request) { ad, error in
            if let error = error {
                print("❌ Erreur chargement interstitielle: \(error.localizedDescription)")
                // En cas d'erreur, appeler directement le callback pour continuer
                DispatchQueue.main.async {
                    self.onAdDismissed?()
                }
                return
            }
            
            if let ad = ad {
                // Stocker l'annonce et définir le delegate
                coordinator.currentAd = ad
                ad.fullScreenContentDelegate = coordinator
                ad.present(from: controller)
            } else {
                // Si l'annonce n'est pas chargée, appeler le callback
                DispatchQueue.main.async {
                    self.onAdDismissed?()
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onAdDismissed: onAdDismissed)
    }
    
    class Coordinator: NSObject, FullScreenContentDelegate {
        var onAdDismissed: (() -> Void)?
        var currentAd: InterstitialAd?
        
        init(onAdDismissed: (() -> Void)? = nil) {
            self.onAdDismissed = onAdDismissed
        }
        
        // Called when the ad dismissed full screen content.
        func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
            print("✅ Interstitielle fermée")
            onAdDismissed?()
            currentAd = nil
        }
        
        // Called when the ad failed to present full screen content.
        func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
            print("❌ Erreur présentation interstitielle: \(error.localizedDescription)")
            currentAd = nil
        }
    }
}
