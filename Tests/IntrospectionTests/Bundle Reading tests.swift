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
    
    
    func testSwiftBundleVersion() {
        XCTAssertEqual(Bundle(path: "/usr/lib/swift")!.version, SemVer(0,0,0, preRelease: ["ERROR", "BundleInfoDictionaryValueNotFound", "CFBundleShortVersionString"]))
        XCTAssertEqual(Bundle(path: "/usr/lib/swift")!.version.description, "0.0.0-ERROR.BundleInfoDictionaryValueNotFound.CFBundleShortVersionString")
    }
}
