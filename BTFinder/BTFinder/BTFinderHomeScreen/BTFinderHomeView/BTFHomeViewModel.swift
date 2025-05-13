//
//  BTFHomeViewModel.swift
//  BTFinder
//
//  Created by Eugene Kolesnikov on 13.05.2025.
//

import Foundation

struct BTFHomeScreenState: Equatable {
    let isLoading: Bool
    let error: String?
}

protocol IBTFHomeViewModel: AnyObject {
    func findBTs() async throws -> [String]
}

final class BTFHomeViewModel: IBTFHomeViewModel {
    
    // MARK: - private properties
    private var state: BTFHomeScreenState = .init(isLoading: false, error: nil)
    
    init() {}
    
    // MARK: - public methods
    func findBTs() async throws -> [String] {
        return []
    }
}
