//
//  PremiumManager.swift
//  FriendZone
//
//  Created by williams saadi on 04/10/2025.
//

import Foundation
import StoreKit

extension Notification.Name {
    static let premiumStatusChanged = Notification.Name("premiumStatusChanged")
}

@MainActor
final class PremiumManager: ObservableObject {
    @Published var isPremiumActive: Bool = false {
        didSet {
            UserDefaults.standard.set(isPremiumActive, forKey: "isPremiumPurchased")
            print("✅ Premium status changed: \(isPremiumActive)")

            NotificationCenter.default.post(
                name: .premiumStatusChanged,
                object: self,
                userInfo: ["isPremiumActive": isPremiumActive]
            )
        }
    }

    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var purchaseStatusMessage: String? = nil
    @Published var products: [Product] = []

    private let premiumProductID = "friendzone_premium"
    private var transactionUpdatesTask: Task<Void, Never>?

    init() {
        transactionUpdatesTask = observeTransactionUpdates()

        Task {
            await refreshPremiumStatus()
            await loadProducts()
        }

        print("🚀 StoreKit 2 purchases enabled")
    }

    deinit {
        transactionUpdatesTask?.cancel()
    }

    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        purchaseStatusMessage = nil

        do {
            let fetchedProducts = try await Product.products(for: [premiumProductID])
            products = fetchedProducts.sorted { $0.id < $1.id }
            isLoading = false

            if let product = premiumProduct {
                clearError()
                purchaseStatusMessage = "Offre disponible"
                print("✅ Produit chargé : \(product.displayName) - \(product.displayPrice)")
                print("   Description : \(product.description)")
                print("   ID : \(product.id)")
            } else {
                errorMessage = "Aucun produit disponible pour le moment."
                print("⚠️ Aucun produit disponible")
            }
        } catch {
            isLoading = false
            products = []
            errorMessage = "Impossible de charger l’offre : \(error.localizedDescription)"
            print("❌ Erreur StoreKit : \(error.localizedDescription)")
        }
    }

    func loadProducts() {
        Task {
            await loadProducts()
        }
    }

    func purchasePremium() {
        Task {
            await purchasePremiumFlow()
        }
    }

    private func purchasePremiumFlow() async {
        guard let product = premiumProduct else {
            errorMessage = "Produit non disponible. Veuillez réessayer."
            print("❌ Produit non disponible pour l'achat")
            return
        }

        isLoading = true
        errorMessage = nil
        purchaseStatusMessage = "Achat en cours..."

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await complete(transaction: transaction, statusMessage: "Pack Premium activé.")
            case .userCancelled:
                isLoading = false
                purchaseStatusMessage = "Achat annulé."
                print("❌ Achat annulé par l'utilisateur")
            case .pending:
                isLoading = false
                errorMessage = "Achat en attente d'approbation parentale."
                purchaseStatusMessage = nil
                print("⏳ Achat différé - en attente d'approbation")
            @unknown default:
                isLoading = false
                errorMessage = "État d'achat inconnu."
                purchaseStatusMessage = nil
                print("❓ État d'achat inconnu")
            }
        } catch {
            isLoading = false
            errorMessage = "Échec de l'achat : \(error.localizedDescription)"
            purchaseStatusMessage = nil
            print("❌ Échec de l'achat : \(error.localizedDescription)")
        }
    }

    func restorePurchases() {
        Task {
            isLoading = true
            errorMessage = nil
            purchaseStatusMessage = "Restauration en cours..."
            print("🔄 Début de la restauration des achats...")

            do {
                try await AppStore.sync()
                await refreshPremiumStatus()
                isLoading = false

                if isPremiumActive {
                    purchaseStatusMessage = "Achat restauré avec succès."
                    clearError()
                    print("✅ Achat restauré avec succès !")
                } else {
                    purchaseStatusMessage = nil
                    errorMessage = "Aucun achat précédent trouvé à restaurer."
                    print("⚠️ Aucun achat à restaurer")
                }
            } catch {
                isLoading = false
                purchaseStatusMessage = nil
                errorMessage = "Échec de la restauration : \(error.localizedDescription)"
                print("❌ Échec de la restauration : \(error.localizedDescription)")
            }
        }
    }

    var premiumProduct: Product? {
        products.first { $0.id == premiumProductID }
    }

    var premiumDisplayName: String {
        premiumProduct?.displayName ?? "Pack Premium FriendZone"
    }

    var premiumDescription: String {
        premiumProduct?.description ?? "Débloque toutes les questions premium et supprime les publicités."
    }

    var premiumDisplayPrice: String {
        premiumProduct?.displayPrice ?? "Prix indisponible"
    }

    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task.detached(priority: .background) {
            for await update in Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(update)
                    await self.complete(transaction: transaction, statusMessage: "Pack Premium activé.")
                } catch {
                    print("❌ Transaction non vérifiée : \(error.localizedDescription)")
                }
            }
        }
    }

    private func refreshPremiumStatus() async {
        var hasPremium = false

        for await result in Transaction.currentEntitlements {
            guard let transaction = try? checkVerified(result) else {
                continue
            }

            if transaction.productID == premiumProductID {
                hasPremium = true
                break
            }
        }

        isPremiumActive = hasPremium
    }

    private func complete(transaction: Transaction, statusMessage: String) async {
        guard transaction.productID == premiumProductID else {
            await transaction.finish()
            return
        }

        isPremiumActive = true
        isLoading = false
        clearError()
        purchaseStatusMessage = statusMessage
        await transaction.finish()
        print("✅ Transaction finalisée : \(transaction.productID)")
    }

    private func clearError() {
        errorMessage = nil
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified(_, let error):
            throw error
        }
    }
}
