//
//  BTFHomeViewModel.swift
//  BTFinder
//
//  Created by Eugene Kolesnikov on 13.05.2025.
//

import Foundation
import Combine

struct BTFHomeScreenState: Equatable {
    let isLoading: Bool
    let error: String?
}

protocol IBTFHomeViewModel: AnyObject {
    var devices: AnyPublisher<[BTFResultsItem], Never> { get }
    var devicesList: [BTFResultsItem] { get }
    var isLoading: AnyPublisher<Bool, Never> { get }
    
    func findBTs()
}

final class BTFHomeViewModel: IBTFHomeViewModel {
    
    // MARK: - Private backing storage
    @Published private(set) var devicesList: [BTFResultsItem] = []
    @Published private var _isLoading: Bool = false
    
    // MARK: - Public publishers (protocol conformance)
    var devices: AnyPublisher<[BTFResultsItem], Never> {
        $devicesList.eraseToAnyPublisher()
    }
    
    var isLoading: AnyPublisher<Bool, Never> {
        $_isLoading.eraseToAnyPublisher()
    }
    
    // MARK: - Dependencies
    private let useCase: IFindBluetoothDevicesUseCase
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(useCase: IFindBluetoothDevicesUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Public API
    func findBTs() {
        _isLoading = true
        
        useCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] deviceList in
                self?.devicesList = deviceList.map { .device(BTFDevice(name: $0.name)) }
                self?._isLoading = false
            }
            .store(in: &cancellables)
    }
}
