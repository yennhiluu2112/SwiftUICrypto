//
//  Date.swift
//  SwiftUICrypto
//
//  Created by Luu Yen Nhi on 24/11/24.
//

import Foundation

extension Date {
    
    init(coinGeckoStr: String){
        let formartter = DateFormatter()
        formartter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formartter.date(from: coinGeckoStr) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormartter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func asShortDateString() -> String {
        return shortFormartter.string(from: self)
    }
}
