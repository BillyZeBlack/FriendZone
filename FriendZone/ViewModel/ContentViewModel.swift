//
//  ContentViewModel.swift
//  FriendZone
//
//  Created by williams saadi on 11/11/2024.
//

import Foundation

class ContentViewModel: ObservableObject {
    
    @Published var hasPremiumPack: Bool = false {
        didSet {
            if hasPremiumPack {
                UserDefaults.standard.set(true, forKey: "hasPremiumPack")
            }
        }
    }
    
    func adaptPronom(response: String, genre: Bool) -> String {
        let adapted = response
            .replacingOccurrences(of: "Elle/Il", with: genre ? "Il" : "Elle")
            .replacingOccurrences(of: "elle/il", with: genre ? "il" : "elle")
            .replacingOccurrences(of: "elle/Il", with: genre ? "il" : "elle")
            .replacingOccurrences(of: "Elle/Lui", with: genre ? "Lui" : "Elle")
            .replacingOccurrences(of: "elle/lui", with: genre ? "lui" : "elle")
            .replacingOccurrences(of: "lui/elle", with: genre ? "lui" : "elle")
            .replacingOccurrences(of: "é(e)", with: genre ? "é" : "ée")
            .replacingOccurrences(of: "t(e)", with: genre ? "t" : "te")
            .replacingOccurrences(of: "i(e)", with: genre ? "i" : "ie")
            .replacingOccurrences(of: "r(e)", with: genre ? "r" : "re")
            .replacingOccurrences(of: "x(se)", with: genre ? "x" : "se")
            .replacingOccurrences(of: "l(e)", with: genre ? "l" : "le")
            .replacingOccurrences(of: "f(ve)", with: genre ? "f" : "ve")
            .replacingOccurrences(of: "n(e)", with: genre ? "n" : "ne")
            .replacingOccurrences(of: "(ne)", with: genre ? "" : "ne")
            .replacingOccurrences(of: "u(e)", with: genre ? "u" : "ue")
        return adapted
    }
}
