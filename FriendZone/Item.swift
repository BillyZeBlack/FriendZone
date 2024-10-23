//
//  Item.swift
//  FriendZone
//
//  Created by williams saadi on 23/10/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
