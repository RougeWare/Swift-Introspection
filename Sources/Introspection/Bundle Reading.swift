//
//  Bundle Reading.swift
//  Swift-Introspection
//
//  Created by Ky Leggiero on 2021-07-24.
//  Copyright Ben 'Ky' Leggiero 2021 BH-1-PS
//

import Foundation

import SemVer



public extension Introspection {
    
    /// Represents the application bundle
    enum Bundle {
        // Empty on-purpose; all members are static
    }
}



public extension Introspection.Bundle {
    
    /// Fetches some object from this bundle's info dictionary
    ///
    /// - Parameters:
    ///   - bundle: _optional_ - The bundle whose info dictionary might have the desired object. Defaults to `.main`
    ///   - key:    The key corresponding to the value you're looking for
    static subscript <Object: BundleObject> (bundle bundle: Foundation.Bundle = .main, _ key: String) -> Object? {
        bundle.infoDictionary?[key] as? Object
    }
}



// MARK: - App Version

public extension Foundation.Bundle {
    
    /// Finds and returns the semantic version of this bundle.
    ///
    /// This uses the bundle's info dictionary's `CFBundleShortVersionString` entry as the major.minor.patch parts of the version, and `CFBundleVersion` as the returned value's build extension.
    /// If `CFBundleShortVersionString` is missing, the returned version contains a semantic error.
    /// If `CFBundleVersion` is missing or empty, it is omitted from the returned version.
    ///
    /// - Note: If that version cannot be found in the bundle's info dictionary, this version is returned:
    ///         `0.0.0-ERROR.BundleInfoDictionaryValueNotFound.CFBundleShortVersionString`
    ///
    /// - Note: If the version found in the bundle's info dictionary isn't a semantic version, this version is returned:
    ///         `0.0.0-ERROR.BundleInfoDictionaryValueInvalidFormat.CFBundleShortVersionString`
    var version: SemVer {
        guard let versionString = infoDictionary?["CFBundleShortVersionString"] as? String else {
            return .error(title: "BundleInfoDictionaryValueNotFound", details: "CFBundleShortVersionString")
        }
        
        guard var baseVersion = SemVer(versionString) else {
            return .error(title: "BundleInfoDictionaryValueInvalidFormat", details: "CFBundleShortVersionString")
        }
        
        guard
            let buildString = infoDictionary?["CFBundleVersion"] as? String,
            !buildString.isEmpty
        else {
            return baseVersion
        }
        
        if !buildString.isEmpty {
            baseVersion.build = .init(buildString)
        }
        
        return baseVersion
    }
}



public extension Introspection.Bundle {
    
    /// Finds and returns the semantic version of the application bundle.
    ///
    /// This uses the bundle's info dictionary's `CFBundleShortVersionString` entry as the major.minor.patch parts of the version, and `CFBundleVersion` as the returned value's build extension.
    /// If `CFBundleShortVersionString` is missing, the returned version contains a semantic error.
    /// If `CFBundleVersion` is missing or empty, it is omitted from the returned version.
    ///
    /// - Note: If that version cannot be found in the bundle's info dictionary, this version is returned:
    ///         `0.0.0-ERROR.BundleInfoDictionaryValueNotFound.CFBundleShortVersionString`
    ///
    /// - Note: If the version found in the bundle's info dictionary isn't a semantic version, this version is returned:
    ///         `0.0.0-ERROR.BundleInfoDictionaryValueInvalidFormat.CFBundleShortVersionString`
    static var version: SemVer {
        version(of: .main)
    }
    
    
    /// Finds and returns the semantic version of the given bundle.
    ///
    /// This uses the bundle's info dictionary's `CFBundleShortVersionString` entry as the major.minor.patch parts of the version, and `CFBundleVersion` as the returned value's build extension.
    /// If `CFBundleShortVersionString` is missing, the returned version contains a semantic error.
    /// If `CFBundleVersion` is missing or empty, it is omitted from the returned version.
    ///
    /// - Note: If that version cannot be found in the bundle's info dictionary, this version is returned:
    ///         `0.0.0-ERROR.BundleInfoDictionaryValueNotFound.CFBundleShortVersionString`
    ///
    /// - Note: If the version found in the bundle's info dictionary isn't a semantic version, this version is returned:
    ///         `0.0.0-ERROR.BundleInfoDictionaryValueInvalidFormat.CFBundleShortVersionString`
    static func version(of bundle: Foundation.Bundle) -> SemVer {
        bundle.version
    }
}



public extension Introspection {
    
    /// Finds and returns the semantic version of the application bundle.
    ///
    /// This uses the bundle's info dictionary's `CFBundleShortVersionString` entry as the major.minor.patch parts of the version, and `CFBundleVersion` as the returned value's build extension.
    /// If `CFBundleShortVersionString` is missing, the returned version contains a semantic error.
    /// If `CFBundleVersion` is missing or empty, it is omitted from the returned version.
    ///
    /// - Note: If that version cannot be found in the bundle's info dictionary, this version is returned:
    ///         `0.0.0-ERROR.BundleInfoDictionaryValueNotFound.CFBundleShortVersionString`
    ///
    /// - Note: If the version found in the bundle's info dictionary isn't a semantic version, this version is returned:
    ///         `0.0.0-ERROR.BundleInfoDictionaryValueInvalidFormat.CFBundleShortVersionString`
    @inline(__always)
    static var appVersion: SemVer { Bundle.version }
}



private extension SemVer {
    
    /// Creates a semantic version which represents an error. This allows you to handle error states by passing back semantic objects rather than crashing or throwing errors.
    ///
    /// - Parameters:
    ///   - title:   The title of the error. **Must be a valid SemVer identifier!**
    ///   - details: Additional details about the error. **Each must be a valid SemVer identifier!**
    ///
    /// - Returns: A semantic version depicting this
    static func error(title: String, details: String...) -> Self {
        self.init(0, 0, 0, preRelease: .init(identifiers: ["ERROR", title] + details))
    }
    
    
    func withErrorBuild(title: String, details: String...) -> Self {
        var copy = self
        copy.build = .init(["ERROR", title] + details)
        return copy
    }
}



// MARK: - BundleObject

public protocol BundleObject {}



extension Bool: BundleObject {}

extension UInt: BundleObject {}
extension UInt8: BundleObject {}
extension UInt16: BundleObject {}
extension UInt32: BundleObject {}
extension UInt64: BundleObject {}

extension Int: BundleObject {}
extension Int8: BundleObject {}
extension Int16: BundleObject {}
extension Int32: BundleObject {}
extension Int64: BundleObject {}

extension Float32: BundleObject {}
extension Float64: BundleObject {}

extension NSNumber: BundleObject {}

extension String: BundleObject {}
extension Date: BundleObject {}
extension Data: BundleObject {}

extension Array: BundleObject where Element: BundleObject {}
extension Dictionary: BundleObject where Key == String, Value: BundleObject {}
