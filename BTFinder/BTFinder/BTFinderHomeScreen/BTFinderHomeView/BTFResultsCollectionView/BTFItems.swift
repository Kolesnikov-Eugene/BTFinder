//
//  BTFItems.swift
//  BTFinder
//
//  Created by Eugene Kolesnikov on 15.05.2025.
//

import Foundation

enum BTFResultsSection: Hashable {
    case main
}

enum BTFResultsItem: Hashable, Equatable {
    case device(BTFDevice)
}

struct BTFDevice: Hashable {
    let identifier: UUID
    let name: String
    var isConnected: Bool = false

    var connectionStatus: String {
        isConnected ? "Connected" : "Not Connected"
    }
}
