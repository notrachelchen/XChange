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
    var timeLastUpdateUnix: TimeInterval
    var rates: [String: Double]
}

