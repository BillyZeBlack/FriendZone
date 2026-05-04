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

    private let premiumProductID = "fdz_premium_pack_1.99"
    private var transactionUpdatesTask: Task<Void, Never>?
    private var purchaseIntentsTask: Task<Void, Never>?

    init() {
        transactionUpdatesTask = observeTransactionUpdates()
        purchaseIntentsTask = observePurchaseIntents()

        Task {
            await refreshPremiumStatus()
            await loadProducts()
        }
    }

    deinit {
        transactionUpdatesTask?.cancel()
        purchaseIntentsTask?.cancel()
    }

//    func loadProducts() async {
//        isLoading = true
//        errorMessage = nil
//        purchaseStatusMessage = nil
//
//        do {
//            let fetchedProducts = try await Product.products(for: [premiumProductID])
//            products = fetchedProducts.sorted { $0.id < $1.id }
//            isLoading = false
//
//            if let product = premiumProduct {
//                clearError()
//                purchaseStatusMessage = "Offre disponible"
//            } else {
//                errorMessage = "Aucun produit disponible pour le moment."
//            }
//        } catch {
//            isLoading = false
//            products = []
//            errorMessage = "Impossible de charger l’offre : \(error.localizedDescription)"
//        }
//    }
    
    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        purchaseStatusMessage = nil

        do {
            let fetchedProducts = try await Product.products(for: [premiumProductID])

            products = fetchedProducts.sorted { $0.id < $1.id }
            isLoading = false

            if fetchedProducts.first != nil {
                clearError()
                purchaseStatusMessage = "Offre disponible"
            } else {
                errorMessage = "Aucun produit disponible pour le moment."
            }
        } catch {
            isLoading = false
            products = []
            errorMessage = "Impossible de charger l’offre : \(error.localizedDescription)"
        }
    }

    func loadProducts() {
        Task {
            await loadProducts()
        }
    }

    func purchasePremium() {
        Task {
            await purchase(product: premiumProduct)
        }
    }

    private func purchase(product optionalProduct: Product?) async {
        guard let product = optionalProduct else {
            errorMessage = "Produit non disponible. Veuillez réessayer."
            return
        }

        guard product.id == premiumProductID else {
            errorMessage = "Produit non reconnu."
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
            case .pending:
                isLoading = false
                errorMessage = "Achat en attente d'approbation parentale."
                purchaseStatusMessage = nil
            @unknown default:
                isLoading = false
                errorMessage = "État d'achat inconnu."
                purchaseStatusMessage = nil
            }
        } catch {
            isLoading = false
            errorMessage = "Échec de l'achat : \(error.localizedDescription)"
            purchaseStatusMessage = nil
        }
    }

    func restorePurchases() {
        Task {
            isLoading = true
            errorMessage = nil
            purchaseStatusMessage = "Restauration en cours..."

            do {
                try await AppStore.sync()
                await refreshPremiumStatus()
                isLoading = false

                if isPremiumActive {
                    purchaseStatusMessage = "Achat restauré avec succès."
                    clearError()
                } else {
                    purchaseStatusMessage = nil
                    errorMessage = "Aucun achat précédent trouvé à restaurer."
                }
            } catch {
                isLoading = false
                purchaseStatusMessage = nil
                errorMessage = "Échec de la restauration : \(error.localizedDescription)"
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
                }
            }
        }
    }

    private func observePurchaseIntents() -> Task<Void, Never> {
        Task.detached(priority: .background) {
            for await purchaseIntent in PurchaseIntent.intents {
                await self.purchase(product: purchaseIntent.product)
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
