//
//  String.swift
//  SwiftUICrypto
//
//  Created by Luu Yen Nhi on 24/11/24.
//

import Foundation

extension String {
    var removingHTML: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
