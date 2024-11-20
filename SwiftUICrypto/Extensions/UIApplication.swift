//
//  UIApplication.swift
//  SwiftUICrypto
//
//  Created by Luu Yen Nhi on 19/11/24.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditting() {
        // unfocus
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
