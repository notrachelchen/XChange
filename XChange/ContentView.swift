//
//  ContentView.swift
//  XChange
//
//  Created by Rachel Chen on 11/21/25.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var exchangeHelper: ExchangeHelper
    
    @State private var showProgress: Bool = false
    @State private var exchangeInfo: ExchangeInfo?
    @State private var baseCurrency: String = "USD"
    @State private var errorMessage: String?
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Exchange\nRates for:")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                
                TextField("", text: $baseCurrency)
                    .font(.system(size: 20, weight: .medium))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .textFieldStyle(.plain)
                    .autocapitalization(.allCharacters)
                    .disableAutocorrection(true)
                    .focused($isFocused)
                    .onSubmit {
                        submitCurrency()
                    }
                    .frame(width: 150)
                
                Spacer()
                
                Button(action: {
                    submitCurrency()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title3)
                        .foregroundColor(.green)
                }
            }
            .padding()
            
            if showProgress {
                Spacer()
                ProgressView()
                Spacer()
            } else if let exchangeInfo = exchangeInfo {
                List {
                    ForEach(sortedCurrencies, id: \.0) { currency, rate in
                        HStack {
                            Text(currency)
                                .font(.system(size: 16))
                            
                            Spacer()
                            
                            Text("\(currency) \(formatRate(rate))")
                                .font(.system(size: 16))
                                .foregroundColor(.primary)
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .onTapGesture {
                    isFocused = false
                }
                
                // Footer
                VStack(spacing: 8) {
                    Text("Last updated: \(formattedDate(Date(timeIntervalSince1970: exchangeInfo.timeLastUpdateUnix)))")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    Text("Rates by Exchange Rate API")
                        .font(.caption)
                        .foregroundColor(.green)
                    
                    Link("TERMS OF SERVICE", destination: URL(string: "https://www.exchangerate-api.com/terms")!)
                        .font(.caption2)
                        .foregroundColor(.green)
                }
                .padding(.bottom, 16)
            } else {
                Spacer()
                
                VStack(spacing: 8) {
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                    Text("Rates by Exchange Rate API")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                .padding(.bottom, 16)
            }
        }
        .onAppear {
            if let cachedData = exchangeHelper.loadCachedRates() {
                exchangeInfo = cachedData
            } else {
                Task {
                    await loadRates()
                }
            }
        }
    }
    
    private var sortedCurrencies: [(String, Double)] {
        exchangeInfo?.rates.sorted { $0.key < $1.key } ?? []
    }
    
    func submitCurrency() {
        baseCurrency = baseCurrency.uppercased().trimmingCharacters(in: .whitespaces)
        
        isFocused = false
        
        guard !baseCurrency.isEmpty else { return }
        
        Task {
            await loadRates()
        }
    }
    
    func loadRates() async {
        exchangeInfo = nil
        errorMessage = nil
        showProgress = true
        
        do {
            print("Fetching rates for: \(baseCurrency)")
            exchangeInfo = try await exchangeHelper.fetchRates(baseCurrency: baseCurrency)
            print("Successfully fetched \(exchangeInfo?.rates.count ?? 0) rates")
        } catch {
            print("Error loading rates: \(error)")
            errorMessage = "Failed to load rates for \(baseCurrency). Error: \(error.localizedDescription)"
        }
        showProgress = false
    }
    
    func formatRate(_ rate: Double) -> String {
        if rate < 1 {
            return String(format: "%.2f", rate)
        } else if rate < 100 {
            return String(format: "%.2f", rate)
        } else {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            return formatter.string(from: NSNumber(value: rate)) ?? String(format: "%.2f", rate)
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' HH:mm:ss z"
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
        .environmentObject(ExchangeHelper())
}
