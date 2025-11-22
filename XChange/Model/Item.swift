//
//  Item.swift
//  XChange
//
//  Created by Rachel Chen on 11/21/25.
//
import Foundation

struct ExchangeInfo: Codable {
    var result: String
    var baseCode: String
    var timeLastUpdateUtc: String
    var conversionRates: [String: Double]
}

