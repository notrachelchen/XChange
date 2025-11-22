//
//  FileManager+Items.swift
//  XChange
//
//  Created by Rachel Chen on 11/21/25.
//

import Foundation

extension FileManager {
    
    private var fileURL: URL? {
        self.urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("ExchangeInfo.json")
    }
    
}
