//
//  LaunchPage.swift
//  FriendZone
//
//  Created by williams saadi on 21/11/2024.
//

import SwiftUI

struct LaunchPage: View {
	@EnvironmentObject var formData: FormData
	@EnvironmentObject var questionLoader: QuestionLoader
	@EnvironmentObject var resultLoader: ResultLoader
	
	@State var timerFinish = false
	
	var body: some View {
		VStack(spacing: 25) {
			if timerFinish {
				withAnimation {
					IntroducingQuestionView()
						.environmentObject(formData)
						.environmentObject(questionLoader)
						.environmentObject(resultLoader)
						.toolbarRole(.editor)
				}.transition(.slide)
				
			} else {
				VStack {
					Spacer()
					TextShimmer(text: "Friendzone")
						.preferredColorScheme(.dark)
					Spacer()
					Image("slice of digital - NB - fond noir")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: UIScreen.main.bounds.size.width, height: 100)
				}
			}
		}
		.onAppear{
			DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
			timerFinish = true
			})
		}
	}
}

struct launchPage_Previews: PreviewProvider {
	static var previews: some View {
		LaunchPage()
	}
}
