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
	let formData = FormData()
	let questionLoader = QuestionLoader()
	let resultLoader = ResultLoader()

    var body: some Scene {
        WindowGroup {
			NavigationView{
				LaunchPage()
			}
			.environmentObject(formData)
			.environmentObject(questionLoader)
			.environmentObject(resultLoader)
        }
    }
}
