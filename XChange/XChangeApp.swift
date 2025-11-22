//
//  XChangeApp.swift
//  XChange
//
//  Created by Rachel Chen on 11/21/25.
//

import SwiftUI
enum URLError: Error {
    case BadURL, BadData
}

@main
struct XChangeApp: App {
    let exchangeHelper = ExchangeHelper()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(exchangeHelper)
        }
    }
}
