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
    
    func readExchangeInfo() -> ExchangeInfo? {
        guard let fileURL = fileURL,
              let data = try? Data(contentsOf: fileURL) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try? decoder.decode(ExchangeInfo.self, from: data)
    }
    
    func writeExchangeInfo(_ info: ExchangeInfo) {
        guard let fileURL = fileURL else { return }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        if let data = try? encoder.encode(info) {
            try? data.write(to: fileURL)
        }
    }
    
}
