//
//  Item.swift
//  SwiftUIPages
//
//  Created by Jeffy on 2024/12/29.
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
