//
//  PremiumManager.swift
//  FriendZone
//
//  Created by williams saadi on 04/10/2025.
//

import Foundation
import StoreKit

class PremiumManager: ObservableObject {
    @Published var isPremiumActive: Bool = false {
        didSet {
            // Synchroniser avec ContentViewModel
            if let contentVM = contentViewModel {
                contentVM.hasPremiumPack = isPremiumActive
            }
        }
    }
    
    // Référence à ContentViewModel pour synchronisation
    weak var contentViewModel: ContentViewModel?
    
    // Pour les tests : variable pour activer/désactiver manuellement
    @Published var isTestMode: Bool = true
    
    init() {
        // Pour les tests, on peut initialiser avec un état par défaut
        #if DEBUG
        isTestMode = true
        #endif
    }
    
    // Fonction pour activer/désactiver premium (pour les tests)
    func togglePremium() {
        if isTestMode {
            isPremiumActive.toggle()
            print("🎯 Premium \(isPremiumActive ? "activé" : "désactivé") (mode test)")
        }
    }
    
    // Fonction pour acheter via AppStore (à implémenter plus tard)
    func purchasePremium() {
        print("🛒 Début du processus d'achat premium")
        
        // Pour l'instant, on simule l'achat en mode test
        if isTestMode {
            isPremiumActive = true
            print("✅ Achat premium simulé avec succès")
        } else {
            // Ici on intégrera l'achat réel via StoreKit
            print("📱 Intégration AppStore à venir")
        }
    }
    
    // Fonction pour restaurer les achats
    func restorePurchases() {
        print("🔄 Tentative de restauration des achats")
        
        if isTestMode {
            isPremiumActive = true
            print("✅ Restauration simulée avec succès")
        } else {
            // Ici on intégrera la restauration via StoreKit
            print("📱 Restauration AppStore à venir")
        }
    }
}
