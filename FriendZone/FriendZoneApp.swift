//
//  FriendZoneApp.swift
//  FriendZone
//
//  Created by williams saadi on 23/10/2024.
//

import SwiftUI
import SwiftData
import AppTrackingTransparency
import AdSupport

@main
struct FriendZoneApp: App {
	@StateObject private var formData = FormData()
	@StateObject private var questionLoader = QuestionLoader()
	@StateObject private var resultLoader = ResultLoader()
	@StateObject private var premiumManager = PremiumManager()
	@StateObject private var contentVM = ContentViewModel()

    var body: some Scene {
        WindowGroup {
			NavigationView{
				LaunchPage()
			}
			.environmentObject(formData)
			.environmentObject(questionLoader)
			.environmentObject(resultLoader)
			.environmentObject(premiumManager)
			.environmentObject(contentVM)
			.onAppear {
				// Demander l'autorisation de suivi (ATT) après un court délai
				DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
					requestTrackingAuthorization()
				}
			}
        }
    }
	
	private func requestTrackingAuthorization() {
		// Vérifier si nous sommes sur iOS 14.5+
		if #available(iOS 14.5, *) {
			ATTrackingManager.requestTrackingAuthorization { status in
				switch status {
				case .authorized:
					print("✅ Autorisation de suivi accordée")
					// L'IDFA est maintenant disponible pour les publicités
					let idfa = ASIdentifierManager.shared().advertisingIdentifier
					print("IDFA: \(idfa)")
				case .denied:
					print("❌ Autorisation de suivi refusée")
				case .notDetermined:
					print("⏳ Autorisation non déterminée")
				case .restricted:
					print("🚫 Autorisation restreinte")
				@unknown default:
					print("❓ État d'autorisation inconnu")
				}
			}
		} else {
			print("📱 iOS version < 14.5, ATT non requis")
		}
	}
}
