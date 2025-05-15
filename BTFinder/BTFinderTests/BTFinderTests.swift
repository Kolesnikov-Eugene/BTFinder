//
//  BTFinderTests.swift
//  BTFinderTests
//
//  Created by Eugene Kolesnikov on 13.05.2025.
//

import XCTest
import Combine
@testable import BTFinder

final class BTFHomeViewModelTests: XCTestCase {
    
    private var viewModel: IBTFHomeViewModel!
    private var mockUseCase: MockFindBluetoothDevicesUseCase!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        mockUseCase = MockFindBluetoothDevicesUseCase()
        viewModel = BTFHomeViewModel(useCase: mockUseCase)
        cancellables = []
    }
    
    override func tearDownWithError() throws {
        cancellables = nil
        viewModel = nil
        mockUseCase = nil
    }
    
    func testFindBTs_PopulatesDevicesList() {
        // Given
        let expectation = XCTestExpectation(description: "Devices list updated")
        let dummyDevices = [
            BluetoothDevice(identifier: UUID(), name: "Device A"),
            BluetoothDevice(identifier: UUID(), name: "Device B")
        ]
        mockUseCase.devicesToReturn = dummyDevices
        
        // When
        viewModel.devices
            .dropFirst()
            .sink { devices in
                XCTAssertEqual(devices.count, 2)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.findBTs()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testConnectToDevice_UpdatesConnectionStatus() {
        // Given
        let expectation = XCTestExpectation(description: "Device connection status updated")

        let uuid = UUID()
        let device = BluetoothDevice(identifier: uuid, name: "Test Device")
        mockUseCase.devicesToReturn = [device]
        mockUseCase.connectionResult = true

        var updateCount = 0

        viewModel.devices
            .sink { items in
                guard let first = items.first, case .device(let updatedDevice) = first else { return }
                updateCount += 1

                if updateCount == 2 {
                    XCTAssertEqual(updatedDevice.identifier, uuid)
                    XCTAssertEqual(updatedDevice.name, "Test Device")
                    XCTAssertTrue(updatedDevice.isConnected)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // When
        viewModel.findBTs()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.viewModel.connectToDevice(at: 0)
        }

        // Then
        wait(for: [expectation], timeout: 2.0)
    }
}
