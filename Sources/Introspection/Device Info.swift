//
//  Device Info.swift
//  Swift-Introspection
//
//  Created by Ky Leggiero on 2021-07-24.
//  Copyright Ben 'Ky' Leggiero 2021 BH-1-PS
//

import Foundation

#if os(macOS)
import IOKit
#elseif os(iOS) || os(tvOS)
import UIKit
#endif

import SafeStringIntegerAccess
import SpecialString



public extension Introspection {
    
    /// Represents the current device
    @dynamicMemberLookup
    struct Device {
        
        /// The device's model type, like `.macPro` or `.iPhone`
        public let modelType: ModelType
        
        /// The broad class of the device, like “desktop” or “phone”.
        ///
        /// `nil` signifies that it's unknown.
        public let deviceClass: Class?
        
        
        /// Creates a new `Device` value
        ///
        /// - Parameters:
        ///   - modelType: The device's model type, like `.macBookPro` or `.iPad`
        ///   - `class`:  _optional_ - The device's class, like `.laptop` or `.tablet`. Defaults to inferring this from the model type.
        public init(modelType: ModelType, `class`: Class? = nil) {
            self.modelType = modelType
            self.deviceClass = `class` ?? modelType.deviceClass
        }
        
        
        /// Allows you to access any info about the device's model type as if it's info about the device
        public subscript <Value> (dynamicMember keyPath: KeyPath<ModelType, Value>) -> Value {
            self.modelType[keyPath: keyPath]
        }
        
        
        /// Allows you to access any info about the current device as a static member of the `Device` type
        public static subscript <Value> (dynamicMember keyPath: KeyPath<Device, Value>) -> Value {
            Self.current[keyPath: keyPath]
        }
    }
}



extension Introspection.Device: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.modelType == rhs.modelType
    }
}



// MARK: - Device Model

public extension Introspection.Device {
    enum ModelType_SpecialStringSpecialType: SpecialStringSpecialType {}
    typealias ModelType = SpecialString<ModelType_SpecialStringSpecialType>
}



public extension Introspection.Device {
    
    /// The  current device's hardware model type, like `"MacBookPro"` or `"iPad"`
    ///
    /// - Note: This relies on the return value from `sysctl`. There is a chance that it will not return a value at all, in which case, the value returned from this will be `.unknown`
    @inline(__always)
    static var modelType: ModelType { .current }
    
    
    /// The hardware model identifier, like `"MacBookPro16,1"` or `"iPad13,2"`
    static var hardwareModelIdentifierString: String? {
        #if os(macOS)
        ioRegistryCfProperty(key: "model")
        #elseif os(iOS) || os(tvOS)
        UIDevice.current.modelName
        #endif
    }
}



public extension Introspection.Device.ModelType {
    
    
    /// The  current device's hardware model type, like `"MacBookPro"` or `"iPad"`
    ///
    /// - Note: This relies on the return value from `sysctl`. There is a chance that it will not return a value at all, in which case, the value returned from this will be `.unknown`
    static var current: Self {
        guard let identifier = Introspection.Device.hardwareModelIdentifierString else {
            return .unknown
        }
        
        guard
            let matchRange = hardwareModelRegex
                .firstMatch(in: identifier, options: .anchored, range: NSRange(location: 0, length: identifier.count))?
                .range(withName: "Type"),
            let type = identifier[orNil: matchRange]
        else {
            // Not an Apple-format identifier; just return the string itself
            return .init(identifier)
        }
        
        return .init(.init(type))
    }
    
    
    /// Splits something like `"MacBookAir9,1"` into the groups `"Type"` (`"MacBookAir"`), `"Version"` (`"9,1"`), `"MajorVersion"` (`"9"`), and `"MinorVersion"` (`"1"`)
    private static let hardwareModelRegex = try! NSRegularExpression(pattern: #"^(?<Type>\w+?)(?<Version>(?<MajorVersion>\d+),(?<MinorVersion>\d+))$"#, options: [])
}



// MARK: Enumerated

public extension Introspection.Device {
    
    /// The current device
    static var current: Self { self.init(modelType: .current) }
    
    
    // There's a bug in the Swift compiler that makes this impossible, so I have to enumerate them by-hand:
    
//    /// Allows you to get any device for which there is already a `ModelType` defined
//    @inline(__always)
//    static subscript (dynamicMember keyPath: KeyPath<ModelType.Type, ModelType>) -> Self {
//        self.init(modelType: ModelType.self[keyPath: keyPath])
//    }
    
    
    /// Represents Apple's MacBook
    static let macBook = Self(modelType: .macBook)
    
    /// Represents Apple's MacBook Air
    static let macBookAir = Self(modelType: .macBookAir)
    
    /// Represents Apple's MacBook Pro
    static let macBookPro = Self(modelType: .macBookPro)
    
    
    /// Represents Apple's iMac
    static let iMac = Self(modelType: .iMac)
    
    /// Represents Apple's iMac Pro
    static let iMacPro = Self(modelType: .iMacPro)
    
    /// Represents Apple's Mac mini
    static let macMini = Self(modelType: .macMini)
    
    /// Represents Apple's Mac Pro
    static let macPro = Self(modelType: .macPro)
    
    
    /// Represents Apple's iPhone
    static let iPhone = Self(modelType: .iPhone)
    
    /// Represents Apple's iPod
    static let iPod = Self(modelType: .iPod)
    
    /// Represents Apple's iPad, iPad mini, and iPad Pro
    static let iPad = Self(modelType: .iPad)
    
    
    /// Represents Apple's Watch
    static let watch = Self(modelType: .watch)
    
    /// Represents Apple's TV
    static let tv = Self(modelType: .tv)
    
    
    /// Represents Apple's i386 iPhone Simulator
    static let iPhoneSimulator_i386 = Self(modelType: .iPhoneSimulator_i386)
    
    /// Represents Apple's x86_64 iPhone Simulator
    static let iPhoneSimulator_x86_64 = Self(modelType: .iPhoneSimulator_x86_64)
    
    /// Represents Apple's arm64 iPhone Simulator
    static let iPhoneSimulator_arm64 = Self(modelType: .iPhoneSimulator_arm64)
    
    /// Represents a VMWare virtual machine
    static let vm_vmware = Self(modelType: .vm_vmware)
}



public extension Introspection.Device.ModelType {
    
    /// The model type prefix for Apple's MacBook
    static let macBook: Self = "MacBook"
    
    /// The model type prefix for Apple's MacBook Air
    static let macBookAir: Self = "MacBookAir"
    
    /// The model type prefix for Apple's MacBook Pro
    static let macBookPro: Self = "MacBookPro"
    
    
    /// The model type prefix for Apple's iMac
    static let iMac: Self = "iMac"
    
    /// The model type prefix for Apple's iMac Pro
    static let iMacPro: Self = "iMacPro"
    
    /// The model type prefix for Apple's Mac mini
    static let macMini: Self = "Macmini"
    
    /// The model type prefix for Apple's Mac Pro
    static let macPro: Self = "MacPro"
    
    
    /// The model type prefix for Apple's iPhone
    static let iPhone: Self = "iPhone"
    
    /// The model type prefix for Apple's iPod
    static let iPod: Self = "iPod"
    
    /// The model type prefix for Apple's iPad, iPad mini, and iPad Pro
    static let iPad: Self = "iPad"
    
    
    /// The model type prefix for Apple's Watch
    static let watch: Self = "Watch"
    
    /// The model type prefix for Apple's TV
    static let tv: Self = "AppleTV"
    
    
    /// The model type prefix for Apple's i386 iPhone Simulator
    static let iPhoneSimulator_i386: Self = "i386"
    
    /// The model type prefix for Apple's x86_64 iPhone Simulator
    static let iPhoneSimulator_x86_64: Self = "x86_64"
    
    /// The model type prefix for Apple's arm64 iPhone Simulator
    static let iPhoneSimulator_arm64: Self = "arm64"
    
    /// The model type prefix for a VMWare virtual machine
    static let vm_vmware: Self = "VMware"
    
    
    /// A placeholder model type for when the model type cannot be identified
    static let unknown: Self = "__UNKNOWN__"
}



// MARK: Device class

public extension Introspection.Device {
    
    /// A broad class of device, like "desktop" or "phone"
    enum Class {
        
        /// A TV box, like TV
        case tvBox
        
        /// A desktop computer, like iMac or Mac mini
        case desktop
        
        /// A laptop computer, like MacBook Air
        case laptop
        
        /// A tablet, like iPad
        case tablet
        
        /// A phone, like iPhone
        case phone
        
        /// A portable music player, like iPod
        case portableMusicPlayer
        
        /// A watch, like Watch
        case watch
    }
}



public extension Introspection.Device.ModelType {
    
    /// The device class indicated by this model type, or `nil` if that can't be determined
    var deviceClass: Introspection.Device.Class? {
        switch self {
        case .tv:
            return .tvBox
            
        case .iMac, .iMacPro, .macMini, .macPro:
            return .desktop
            
        case .macBook, .macBookAir, .macBookPro:
            return .laptop
            
        case .iPad:
            return .tablet
            
        case .iPhone:
            return .phone
            
        case .iPod:
            return .portableMusicPlayer
            
        case .watch:
            return .watch
            
        default:
            return nil
        }
    }
    
    
    /// Determines whether this model type likely represents a simulator
    var isSimulator: Bool {
        switch self {
        case .iPhoneSimulator_i386,
                .iPhoneSimulator_x86_64,
                .iPhoneSimulator_arm64:
            return true
            
        default:
            return false
        }
    }
    
    
    /// Determines whether this model type likely represents a virtual machine
    var isVirtualMachine: Bool {
        switch self {
        case .vm_vmware:
            return true
            
        default:
            return false
        }
    }
}



// MARK: Tools

private func sysctl(category: CInt, value: CInt) -> String? {
    var mib = [category, value]
    
    var len = size_t()
    var rstring: String?
    
    sysctl(&mib, 2, nil, &len, nil, 0 )
    let mallocated = malloc( len )
    defer {
        free(&rstring )
        rstring = nil
    }
    
    rstring = mallocated?.load(as: String.self)
    
    sysctl(&mib, 2, &rstring, &len, nil, 0 )
    
    return rstring
}



#if os(macOS)
private func ioRegistryCfProperty(key: String) -> String? {
    let service = IOServiceGetMatchingService(kIOMasterPortDefault,
                                              IOServiceMatching("IOPlatformExpertDevice"))
    defer { IOObjectRelease(service) }

    guard let modelData = IORegistryEntryCreateCFProperty(service, key as CFString, kCFAllocatorDefault, 0)?.takeRetainedValue() as? Data else {
        return nil
    }
    
    return String(data: modelData, encoding: .utf8)?
        .trimmingCharacters(in: .controlCharacters)
}
#endif



#if os(iOS) || os(tvOS)
// From https://stackoverflow.com/a/11197770/453435

extension UIDevice {
    
    /// The name of this device model, like `"iPhone13,1"` or `"iPad8,12"`
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        return Mirror(reflecting: systemInfo.machine)
            .children
            .reduce(into: "") { identifier, element in
                guard
                    let value = element.value as? Int8,
                    value != 0
                else {
                    return
                }
                
                identifier += String(UnicodeScalar(UInt8(value)))
            }
    }
}
#endif
