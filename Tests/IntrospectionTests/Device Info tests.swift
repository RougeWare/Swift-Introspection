//
//  Device Info tests.swift
//  Introspection
//
//  Created by Ky Leggiero on 2021-07-24.
//  Copyright Ben 'Ky' Leggiero 2021 BH-1-PS
//

import XCTest
import Introspection



final class DeviceInfoTests: XCTestCase {
    func testCurrentDevice() {
        let current = Introspection.Device.current
        XCTAssertFalse(current.modelType.withoutTypeSafety().isEmpty)
        
        if !current.modelType.isSimulator,
           !current.modelType.isVirtualMachine
        {
            XCTAssertNotNil(current.deviceClass, "Model isn't a simulator, but device class unknown: \(current)")
            
            XCTAssert(current.hardwareModelIdentifier == Introspection.Device.HardwareModelIdentifier.current)
            XCTAssert(nil != current.hardwareModelIdentifier, "Model isn't a simulator, but hardware model identifier is unknown: \(current)")
            XCTAssert(nil != Introspection.Device.hardwareModelIdentifierString, "Model isn't a simulator, but hardware model identifier string is unknown: \(current)")
        }
    }
    
    
    func testDevicePassesThroughToModelType() {
        let testDevice = Introspection.Device(modelType: "TestModelType", class: .desktop)
        XCTAssertEqual(testDevice.modelType, "TestModelType")
        XCTAssertEqual(testDevice.deviceClass, .desktop)
        XCTAssertNil(testDevice.modelType.deviceClass)
        XCTAssertEqual(testDevice.description, testDevice.modelType.description)
    }
    
    
    func testModelTypeInferredClassAccurate() {
        XCTAssertEqual(Introspection.Device.mac.deviceClass, .laptop)
        
        XCTAssertEqual(Introspection.Device.macBook.deviceClass, .laptop)
        XCTAssertEqual(Introspection.Device.macBookAir.deviceClass, .laptop)
        XCTAssertEqual(Introspection.Device.macBookPro.deviceClass, .laptop)
        
        XCTAssertEqual(Introspection.Device.iMac.deviceClass, .desktop)
        XCTAssertEqual(Introspection.Device.iMacPro.deviceClass, .desktop)
        XCTAssertEqual(Introspection.Device.macMini.deviceClass, .desktop)
        XCTAssertEqual(Introspection.Device.macPro.deviceClass, .desktop)
        
        XCTAssertEqual(Introspection.Device.iPhone.deviceClass, .phone)
        
        XCTAssertEqual(Introspection.Device.iPad.deviceClass, .tablet)
        
        XCTAssertEqual(Introspection.Device.iPod.deviceClass, .portableMusicPlayer)
        
        XCTAssertEqual(Introspection.Device.watch.deviceClass, .watch)
        XCTAssertEqual(Introspection.Device.tv.deviceClass, .tvBox)
        
        XCTAssertNil(Introspection.Device.iPhoneSimulator_i386.deviceClass)
        XCTAssertNil(Introspection.Device.iPhoneSimulator_x86_64.deviceClass)
        XCTAssertNil(Introspection.Device.iPhoneSimulator_arm64.deviceClass)
    }
}

