//
//  AdInterstitialManager.swift
//  FriendZone
//
//  Created by Williams SAADI on 02/10/2025.
//

import Foundation
import GoogleMobileAds

@MainActor
final class AdInterstitialManager: NSObject, ObservableObject {
    @Published var shouldShowInterstitial = false
    @Published var isLoading = false
    @Published var lastError: String?
    
    private var currentAd: InterstitialAd?
    private let adUnitID: String //ca-app-pub-8777271534976494~6779301073
    
    var onAdDismissed: (() -> Void)?
    var onAdFailedToLoad: ((Error) -> Void)?
    
    init(adUnitID: String) {
        self.adUnitID = adUnitID
    }
    
    func showInterstitial() {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        lastError = nil
        
        let request = Request()
        InterstitialAd.load(with: adUnitID, request: request) { [weak self] ad, error in
            guard let self = self else { return }
            
            self.isLoading = false
            
            if let error = error {
                self.lastError = error.localizedDescription
                self.onAdFailedToLoad?(error)
                return
            }
            
            if let ad = ad {
                self.currentAd = ad
                ad.fullScreenContentDelegate = self
                self.shouldShowInterstitial = true
            }
        }
    }
    
    func presentInterstitial(from controller: UIViewController) -> Bool {
        guard let ad = currentAd else {
            return false
        }
        ad.present(from: controller)
        return true
    }
    
    func reset() {
        shouldShowInterstitial = false
        currentAd = nil
        isLoading = false
    }
}

// MARK: - FullScreenContentDelegate

extension AdInterstitialManager: FullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        reset()
        onAdDismissed?()
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        reset()
    }
    
    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {}
}
