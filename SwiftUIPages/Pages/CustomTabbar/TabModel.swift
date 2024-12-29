//
//  TabModel.swift
//  SwiftUIPages
//
//  Created by Jeffy on 2024/12/29.
//


import SwiftUI

enum TabModel: String, CaseIterable {
    case home = "square.on.square.dashed"
    case search = "magnifyingglass"
    case notifications = "app.badge"
    case profile = "person"
    
    var title: String {
        switch self {
        case .home: "Home"
        case .search: "Search"
        case .notifications: "Notifications"
        case .profile: "Profile"
        }
    }
}
