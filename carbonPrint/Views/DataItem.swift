//
//  DataItem.swift
//  carbonPrint
//
//  Created by Pelangi Masita Wati on 30/04/24.
//

import Foundation
import SwiftData

@Model
class DataItem: Identifiable {
    
    var id: String
    var name: String
    
    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
    }
}
