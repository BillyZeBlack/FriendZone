//
//  ResultView.swift
//  FriendZone
//
//  Created by williams saadi on 25/10/2024.
//

import SwiftUI
import Charts

struct ResultView: View {
	@EnvironmentObject var formData: FormData
	@EnvironmentObject var resultLoader: ResultLoader
	
	@State var contentVM = ContentViewModel()
	@State var isFlipped: Bool = false
	@State var comment: String = ""
	
	var body: some View {
		VStack {
			if comment.isEmpty {
				Text("Chargement des résultats...")
					.font(.title)
					.foregroundColor(.gray)
			} else {
				ZStack {
					CardView(textContent: comment, textColor: .white, backgroundColor: .gray.opacity(0.5), scolor: .pink, isTrue: 0, isFalse: -90, isFlipped: isFlipped, zoneScore: resultLoader.zoneScore)
						.animation(isFlipped ? .linear.delay(0.35) : .linear, value: isFlipped)
					
					CardChartView(dataScore: resultLoader.dataScore, isFlipped: isFlipped, isTrue: 90, isFalse: 0, scoreResult: resultLoader.score)
						.animation(isFlipped ? .linear : .linear.delay(0.35), value: isFlipped)
				}.onTapGesture {
					withAnimation(.easeIn) {
						isFlipped.toggle()
					}
				}
			}
		}
		.onAppear{
			print("ResultView onAppear - Score: \(resultLoader.score), Zone: \(resultLoader.zoneScore)")
			getCommentResult(ageRange: formData.ageRange)
			print("Comment: \(comment)")
		}
	}
	
	private func getCommentResult(ageRange: Int)
	{
		comment = contentVM.adaptPronom(response: resultLoader.getCommentResult(ageRange: formData.ageRange), genre: formData.partnerGender)
	}
	
	private func resetData()
	{
		resultLoader.resestData()
	}
}

#Preview {
	ResultView()
}
