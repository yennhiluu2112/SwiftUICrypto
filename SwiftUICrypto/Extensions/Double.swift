//
//  Double.swift
//  SwiftUICrypto
//
//  Created by Luu Yen Nhi on 16/11/24.
//

import Foundation

extension Double {
    
    /// Convert a Double to a Currency with 2-6 decimal places
    /// ```
    ///  Convert 1234.56 to $1,234.56
    ///  Convert 12.3456 to $12.3456
    ///  Convert 0.123456 to $0.123456
    /// ```
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current // <- default value
//        formatter.currencyCode = "usd" // <- change curency
//        formatter.currencySymbol = "$" // <- change curency symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current // <- default value
//        formatter.currencyCode = "usd" // <- change curency
//        formatter.currencySymbol = "$" // <- change curency symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    
    /// Convert a Double to a Currency as a String with 2-6 decimal places
    /// ```
    ///  Convert 1234.56 to "$1,234.56"
    ///  Convert 12.3456 to "$12.3456"
    ///  Convert 0.123456 to "$0.123456"
    /// ```
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter.string(from: number) ?? "$0.00"
    }
    
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter2.string(from: number) ?? "$0.00"
    }
    
    /// Convert a Double to a String representation
    /// ```
    ///  Convert 1.2345to "1.23"
    /// ```
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    /// Convert a Double to a String representation with percentage symbol
    /// ```
    ///  Convert 1.2345to "1.23%"
    /// ```
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
}
