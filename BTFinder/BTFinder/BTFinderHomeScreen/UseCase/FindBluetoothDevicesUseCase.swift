//
//  FindBluetoothDevicesUseCase.swift
//  BTFinder
//
//  Created by Eugene Kolesnikov on 14.05.2025.
//

import Foundation
import Combine

struct BluetoothDevice: Hashable {
    let identifier: UUID
    let name: String
}

protocol IFindBluetoothDevicesUseCase: AnyObject {
    func execute() -> AnyPublisher<[BluetoothDevice], Never>
}

final class FindBluetoothDevicesUseCase: IFindBluetoothDevicesUseCase {
    private let service: IBluetoothService

    init(service: IBluetoothService) {
        self.service = service
    }

    func execute() -> AnyPublisher<[BluetoothDevice], Never> {
        service.startScanning(withTimeout: 10)
        return service.foundDevicesPublisher
    }
}
