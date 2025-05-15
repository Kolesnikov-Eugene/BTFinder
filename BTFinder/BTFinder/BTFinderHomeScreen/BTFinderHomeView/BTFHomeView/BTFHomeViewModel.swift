//
//  BTFHomeViewModel.swift
//  BTFinder
//
//  Created by Eugene Kolesnikov on 13.05.2025.
//

import Foundation
import Combine

protocol IBTFHomeViewModel: AnyObject {
    var devices: AnyPublisher<[BTFResultsItem], Never> { get }
    var devicesList: [BTFResultsItem] { get }
    var isLoading: AnyPublisher<Bool, Never> { get }
    
    func findBTs()
    func connectToDevice(at index: Int)
}

final class BTFHomeViewModel: IBTFHomeViewModel {

    // MARK: - Private
    @Published private(set) var devicesList: [BTFResultsItem] = []
    @Published private var _isLoading: Bool = false
    @Published private var _connectedDevice: BTFDevice? = nil

    // Raw devices for internal mapping
    @Published private var rawDevices: [BluetoothDevice] = []

    // MARK: - Publishers
    var devices: AnyPublisher<[BTFResultsItem], Never> {
        $devicesList.eraseToAnyPublisher()
    }

    var isLoading: AnyPublisher<Bool, Never> {
        $_isLoading.eraseToAnyPublisher()
    }

    var connectedDevice: AnyPublisher<BTFDevice?, Never> {
        $_connectedDevice.eraseToAnyPublisher()
    }

    // MARK: - Dependencies
    private let useCase: IFindBluetoothDevicesUseCase
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(useCase: IFindBluetoothDevicesUseCase) {
        self.useCase = useCase

        useCase.connectedDevice
            .receive(on: DispatchQueue.main)
            .sink { [weak self] device in
                self?._connectedDevice = device.map { BTFDevice(identifier: $0.identifier,name: $0.name) }
            }
            .store(in: &cancellables)
    }

    // MARK: - Public API
    func findBTs() {
        _isLoading = true

        useCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] deviceList in
                self?.rawDevices = deviceList
                self?.devicesList = deviceList.map { .device(BTFDevice(identifier: $0.identifier, name: $0.name)) }
                self?._isLoading = false
            }
            .store(in: &cancellables)
    }

    func connectToDevice(at index: Int) {
        guard index < devicesList.count else { return }
        
        if case .device(let device) = devicesList[index] {
            useCase.connect(to: device)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] success in
                    guard let self = self else { return }
                    
                    let updatedDevice = BTFDevice(
                        identifier: device.identifier,
                        name: device.name,
                        isConnected: success
                    )
                    self.devicesList[index] = .device(updatedDevice)
                }
                .store(in: &cancellables)
        }
    }
}
