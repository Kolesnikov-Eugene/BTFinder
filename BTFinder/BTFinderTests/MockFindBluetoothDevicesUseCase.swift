//
//  MockFindBluetoothDevicesUseCase.swift
//  BTFinderTests
//
//  Created by Eugene Kolesnikov on 15.05.2025.
//

import Foundation
import Combine
@testable import BTFinder

final class MockFindBluetoothDevicesUseCase: IFindBluetoothDevicesUseCase {

    var devicesToReturn: [BluetoothDevice] = []
    var connectionResult: Bool = false
    var connectedDeviceSubject = CurrentValueSubject<BluetoothDevice?, Never>(nil)

    var connectedDevice: AnyPublisher<BluetoothDevice?, Never> {
        connectedDeviceSubject.eraseToAnyPublisher()
    }

    func execute() -> AnyPublisher<[BluetoothDevice], Never> {
        return Just(devicesToReturn)
            .eraseToAnyPublisher()
    }

    func connect(to device: BTFDevice) -> AnyPublisher<Bool, Never> {
        return Just(connectionResult)
            .eraseToAnyPublisher()
    }
}
