//
//  HapticManager.swift
//  SwiftUICrypto
//
//  Created by Luu Yen Nhi on 21/11/24.
//

import Foundation
import UIKit

class HapticManager {
    static let generator = UINotificationFeedbackGenerator()
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
}
