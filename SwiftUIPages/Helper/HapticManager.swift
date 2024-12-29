///
//  @filename   HapticManager.swift
//  @package
//
//  @author     jeffy
//  @date       2023/12/13
//  @abstract
//
//  Copyright © 2023 and Confidential to jeffy All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

class HapticManager {
    //MARK: PROPERTIES
    static let shared = HapticManager()
    
    private var lightImpactGenerator: UIImpactFeedbackGenerator?
    
    //MARK: Initialization
    private init() {
        
    }
    
    //MARK: Public Methods
    
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
}
