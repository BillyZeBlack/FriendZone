//
//  FriendZoneApp.swift
//  FriendZone
//
//  Created by williams saadi on 23/10/2024.
//

import SwiftUI
import SwiftData

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
				// Configurer la liaison entre PremiumManager et ContentViewModel
				premiumManager.contentViewModel = contentVM
			}
        }
    }
}
