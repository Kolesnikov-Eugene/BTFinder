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
    var connectedDevicePublisher: AnyPublisher<BluetoothDevice?, Never> { get }

    func startScanning(withTimeout timeout: TimeInterval)
    func stopScanning()
    func connect(to device: BTFDevice) -> AnyPublisher<Bool, Never>
}

final class BluetoothService: NSObject, IBluetoothService {

    // MARK: - private properties
    private var connectedPeripheral: CBPeripheral?
    private var centralManager: CBCentralManager!
    private var devices: [UUID: BluetoothDevice] = [:]
    private let devicesSubject = CurrentValueSubject<[BluetoothDevice], Never>([])
    private let connectedDeviceSubject = CurrentValueSubject<BluetoothDevice?, Never>(nil)
    private var scanTimeoutCancellable: AnyCancellable?
    private let connectionSubject = PassthroughSubject<Bool, Never>()

    var foundDevicesPublisher: AnyPublisher<[BluetoothDevice], Never> {
        devicesSubject.eraseToAnyPublisher()
    }

    var connectedDevicePublisher: AnyPublisher<BluetoothDevice?, Never> {
        connectedDeviceSubject.eraseToAnyPublisher()
    }

    // MARK: - init
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }

    // MARK: - public methods
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
    
    func connect(to device: BTFDevice) -> AnyPublisher<Bool, Never> {
        let peripherals = centralManager.retrievePeripherals(withIdentifiers: [device.identifier])
        guard let peripheral = peripherals.first else {
            connectionSubject.send(false)
            return connectionSubject.eraseToAnyPublisher()
        }

        connectedPeripheral = peripheral
        centralManager.connect(peripheral, options: nil)
        return connectionSubject.eraseToAnyPublisher()
    }
    
    func disconnectCurrentPeripheral() {
        guard let peripheral = connectedPeripheral else { return }
        centralManager.cancelPeripheralConnection(peripheral)
    }
}

// MARK: - CBCentralManagerDelegate
extension BluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // respond to Bluetooth state changes
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
    
    func centralManager(
        _ central: CBCentralManager,
        didConnect peripheral: CBPeripheral
    ) {
        print("Connected to \(peripheral.name ?? "Unknown")")
        if peripheral == connectedPeripheral {
            connectionSubject.send(true)
        }
    }

    func centralManager(
        _ central: CBCentralManager,
        didFailToConnect peripheral: CBPeripheral,
        error: Error?
    ) {
        if peripheral == connectedPeripheral {
            connectionSubject.send(false)
        }
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didDisconnectPeripheral peripheral: CBPeripheral,
        error: Error?
    ) {
        if peripheral == connectedPeripheral {
            connectedPeripheral = nil
        }
        print(" Disconnected from \(peripheral.name ?? "Unknown")")
    }
}
