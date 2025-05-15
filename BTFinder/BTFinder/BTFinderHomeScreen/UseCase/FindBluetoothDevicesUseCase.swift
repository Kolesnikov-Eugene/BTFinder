//
//  FindBluetoothDevicesUseCase.swift
//  BTFinder
//
//  Created by Eugene Kolesnikov on 14.05.2025.
//

import Foundation
import Combine

protocol IFindBluetoothDevicesUseCase {
    func execute() -> AnyPublisher<[BluetoothDevice], Never>
    func connect(to device: BTFDevice) -> AnyPublisher<Bool, Never>
    var connectedDevice: AnyPublisher<BluetoothDevice?, Never> { get }
}

final class FindBluetoothDevicesUseCase: IFindBluetoothDevicesUseCase {
    
    // MARK: - public
    var connectedDevice: AnyPublisher<BluetoothDevice?, Never> {
        service.connectedDevicePublisher
    }

    // MARK: - dependencies
    private let service: IBluetoothService

    // MARK: - init
    init(service: IBluetoothService) {
        self.service = service
    }

    // MARK: - public
    func execute() -> AnyPublisher<[BluetoothDevice], Never> {
        service.startScanning(withTimeout: 10)
        return service.foundDevicesPublisher
    }

    func connect(to device: BTFDevice) -> AnyPublisher<Bool, Never> {
        service.connect(to: device)
    }
}
