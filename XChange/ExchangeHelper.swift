//
//  ExchangeHelper.swift
//  XChange
//
//  Created by Rachel Chen on 11/21/25.
//
import Foundation

class ExchangeHelper: ObservableObject {
    
    private let fileManager = FileManager.default

    func fetchRates(baseCurrency: String = "USD") async throws -> ExchangeInfo {
        
        let urlString = "https://open.er-api.com/v6/latest/\(baseCurrency)"
        
        guard let url = URL(string: urlString) else {
            throw URLError.BadURL
        }
        
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError.BadData
        }
        
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let exchangeInfo = try decoder.decode(ExchangeInfo.self, from: data)
        
       
        fileManager.writeExchangeInfo(exchangeInfo)
        
        return exchangeInfo
    }
    
    func loadCachedRates() -> ExchangeInfo? {
        return fileManager.readExchangeInfo()
    }
}

