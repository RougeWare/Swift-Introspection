//
//  Bundle Reading tests.swift
//  Introspection
//
//  Created by Ky Leggiero on 2021-07-24.
//  Copyright Ben 'Ky' Leggiero 2021 BH-1-PS
//

import XCTest

import Introspection
import SemVer



final class BundleReadingTests: XCTestCase {
    
    func testAppVersion() {
        // I'm not entirely sure how to test this, but I poked through it in the console and it seems to work well
    }
    
    
    func testSwiftBundle() {
        XCTAssertEqual(Introspection.Bundle.id(of: .swift), "ERROR.NO_BUNDLE_ID_FOUND")
        
        XCTAssertEqual(Introspection.Bundle.name(of: .swift), "")
        
        XCTAssertEqual(Introspection.Bundle.version(of: .swift), SemVer(0,0,0, preRelease: ["ERROR", "BundleInfoDictionaryValueNotFound", "CFBundleShortVersionString"]))
        XCTAssertEqual(Introspection.Bundle.version(of: .swift).description, "0.0.0-ERROR.BundleInfoDictionaryValueNotFound.CFBundleShortVersionString")
    }
    
    
    func testFinderBundle() {
        XCTAssertEqual(Introspection.Bundle.id(of: .finder), "com.apple.finder")
        
        XCTAssertEqual(Introspection.Bundle.name(of: .finder), "Finder")
        
        XCTAssertGreaterThan(Introspection.Bundle.version(of: .finder), SemVer(1,0,0))
    }
    
    
    func testThisBundle() {
        
        // MARK: ID
        
        XCTAssertEqual(Introspection.bundleId, "com.apple.dt.xctest.tool")
        XCTAssertEqual(Introspection.Bundle.id, "com.apple.dt.xctest.tool")
        XCTAssertEqual(Introspection.Bundle.id(of: .main), "com.apple.dt.xctest.tool")
        XCTAssertEqual(Bundle.main.id, "com.apple.dt.xctest.tool")
        
        
        // MARK: App Name
        
        XCTAssertEqual(Introspection.appName, "xctest")
        XCTAssertEqual(Introspection.Bundle.name, "xctest")
        XCTAssertEqual(Introspection.Bundle.name(of: .main), "xctest")
        XCTAssertEqual(Bundle.main.name, "xctest")
        
        
        // MARK: Version
        
        XCTAssertGreaterThan(Introspection.appVersion, SemVer(10,0,0))
        XCTAssertGreaterThan(Introspection.Bundle.version, SemVer(10,0,0))
        XCTAssertGreaterThan(Introspection.Bundle.version(of: .main), SemVer(10,0,0))
        XCTAssertGreaterThan(Bundle.main.version, SemVer(10,0,0))
    }
}



private extension Bundle {
    static var swift: Self { Self(path: "/usr/lib/swift")! }
    static var finder: Self { Self(path: "/System/Library/CoreServices/Finder.app")! }
}
