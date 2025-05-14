//
//  BluetoothService.swift
//  BTFinder
//
//  Created by Eugene Kolesnikov on 14.05.2025.
//

import CoreBluetooth
import Combine

protocol IBluetoothService {
    var foundDevicesPublisher: AnyPublisher<[BluetoothDevice], Never> { get }
    func startScanning(withTimeout timeout: TimeInterval)
    func stopScanning()
}

final class BluetoothService: NSObject, IBluetoothService {
    private var centralManager: CBCentralManager!
    private var devices: [UUID: BluetoothDevice] = [:]
    private let devicesSubject = CurrentValueSubject<[BluetoothDevice], Never>([])
    private var scanTimeoutCancellable: AnyCancellable?

    var foundDevicesPublisher: AnyPublisher<[BluetoothDevice], Never> {
        devicesSubject.eraseToAnyPublisher()
    }

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }

    func startScanning(withTimeout timeout: TimeInterval = 10) {
        guard centralManager.state == .poweredOn else { return }

        devices = [:]
        devicesSubject.send([])
        centralManager.scanForPeripherals(withServices: nil, options: nil)

        scanTimeoutCancellable?.cancel()

        scanTimeoutCancellable = Just(())
            .delay(for: .seconds(timeout), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.stopScanning()
            }
    }

    func stopScanning() {
        centralManager.stopScan()
        scanTimeoutCancellable?.cancel()
        scanTimeoutCancellable = nil
    }
}

extension BluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        func centralManagerDidUpdateState(_ central: CBCentralManager) {
//            if central.state == .poweredOn {
//                startScanning()
//            }
        }
    }

    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String : Any],
        rssi RSSI: NSNumber
    ) {
        let id = peripheral.identifier
        let name = peripheral.name ?? (advertisementData[CBAdvertisementDataLocalNameKey] as? String) ?? "Unknown"
        let device = BluetoothDevice(identifier: id, name: name)

        if devices[id] == nil {
            devices[id] = device
            devicesSubject.send(Array(devices.values))
        }
    }
}

//protocol IBluetoothService {
//    var foundDevicesPublisher: AnyPublisher<[BluetoothDevice], Never> { get }
//    func startScanning()
//    func stopScanning()
//}
//
//final class BluetoothService: NSObject, IBluetoothService {
//    private var centralManager: CBCentralManager!
//    private var devices: [UUID: BluetoothDevice] = [:]
//    private let devicesSubject = CurrentValueSubject<[BluetoothDevice], Never>([])
//    
//    var foundDevicesPublisher: AnyPublisher<[BluetoothDevice], Never> {
//        devicesSubject.eraseToAnyPublisher()
//    }
//    
//    override init() {
//        super.init()
//        centralManager = CBCentralManager(delegate: self, queue: .main)
//    }
//    
//    func startScanning() {
//        guard centralManager.state == .poweredOn else { return }
//        devices = [:]
//        centralManager.scanForPeripherals(withServices: nil, options: nil)
//    }
//    
//    func stopScanning() {
//        centralManager.stopScan()
//    }
//}
//
//extension BluetoothService: CBCentralManagerDelegate {
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        if central.state == .poweredOn {
//            startScanning()
//        }
//    }
//    
//    func centralManager(
//        _ central: CBCentralManager,
//        didDiscover peripheral: CBPeripheral,
//        advertisementData: [String : Any],
//        rssi RSSI: NSNumber
//    ) {
//        let id = peripheral.identifier
//        let name = peripheral.name ?? "Unknown"
//        let device = BluetoothDevice(identifier: id, name: name)
//        devices[id] = device
//        devicesSubject.send(Array(devices.values))
//    }
//}
