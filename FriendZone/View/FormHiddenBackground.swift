//
//  FormHiddenBackground.swift
//  FriendZone
//
//  Created by williams saadi on 29/11/2024.
//

/*
 Permet de gérer la couleur de fond du formulaire
*/

import SwiftUI

struct FormHiddenBackground: ViewModifier {
	
	func body(content: Content) -> some View {
		if #available(iOS 16.0, *) {
			content.scrollContentBackground(.hidden)
		} else {
			content.onAppear {
				UITableView.appearance().backgroundColor = .clear
			}
			.onDisappear {
				UITableView.appearance().backgroundColor = .systemGroupedBackground
			}
		}
	}
}
