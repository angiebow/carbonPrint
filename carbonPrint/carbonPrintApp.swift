//
//  carbonPrintApp.swift
//  carbonPrint
//
//  Created by Pelangi Masita Wati on 29/04/24.
//

import SwiftUI
import SwiftData

@main
struct carbonPrintApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: DataItem.self)
    }
}
