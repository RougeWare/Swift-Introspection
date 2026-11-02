//
//  Hardware Model Identifier tests.swift
//  Introspection
//
//  Created by Claude on 2026-11-01.
//

import Testing

import Introspection



private typealias HardwareModelIdentifier = Introspection.Device.HardwareModelIdentifier



@Suite("Introspection.Device.HardwareModelIdentifier")
struct HardwareModelIdentifierTests {

    // MARK: - Memberwise initializers

    @Test("`Version.init(major:minor:)` keeps exactly what it's given, and `full` joins them")
    func versionInitializerKeepsItsArguments() {
        let version = HardwareModelIdentifier.Version(major: 9, minor: 1)

        #expect(9 == version.major)
        #expect(1 == version.minor)
        #expect("9,1" == version.full)
    }


    @Test("`init(type:version:)` keeps exactly what it's given")
    func identifierInitializerKeepsItsArguments() {
        let version = HardwareModelIdentifier.Version(major: 16, minor: 1)
        let identifier = HardwareModelIdentifier(type: "MacBookPro", version: version)

        #expect("MacBookPro" == identifier.type.withoutTypeSafety())
        #expect(version == identifier.version)
    }


    @Test("Identifiers built from equal parts are equal, and hash the same")
    func equalPartsMakeEqualIdentifiers() {
        let first = HardwareModelIdentifier(type: "iPad", version: .init(major: 13, minor: 2))
        let second = HardwareModelIdentifier(type: "iPad", version: .init(major: 13, minor: 2))

        #expect(first == second)
        #expect(first.hashValue == second.hashValue)
        #expect(1 == Set([first, second]).count)
    }


    @Test("Identifiers which differ in any one part are not equal")
    func differentPartsMakeDifferentIdentifiers() {
        let original = HardwareModelIdentifier(type: "iPad", version: .init(major: 13, minor: 2))

        #expect(original != HardwareModelIdentifier(type: "iPhone", version: .init(major: 13, minor: 2)))
        #expect(original != HardwareModelIdentifier(type: "iPad", version: .init(major: 14, minor: 2)))
        #expect(original != HardwareModelIdentifier(type: "iPad", version: .init(major: 13, minor: 3)))
    }



    // MARK: - init?(parsing:)

    struct ValidExample: Sendable {
        let raw: String
        let type: String
        let full: String
        let major: Int
        let minor: Int
    }


    @Test(
        "`init?(parsing:)` splits a valid identifier into its type and version",
        arguments: [
            ValidExample(raw: "MacBookAir9,1",  type: "MacBookAir", full: "9,1",   major: 9,  minor: 1),
            ValidExample(raw: "MacBookPro16,1", type: "MacBookPro", full: "16,1",  major: 16, minor: 1),
            ValidExample(raw: "iPhone18,2",     type: "iPhone",     full: "18,2",  major: 18, minor: 2),
            ValidExample(raw: "iPad13,2",       type: "iPad",       full: "13,2",  major: 13, minor: 2),
            ValidExample(raw: "Mac14,8",        type: "Mac",        full: "14,8",  major: 14, minor: 8),
            ValidExample(raw: "AppleTV6,2",     type: "AppleTV",    full: "6,2",   major: 6,  minor: 2),

            // The digits belong to the version, not to the end of the type
            ValidExample(raw: "iPhone10,3",     type: "iPhone",     full: "10,3",  major: 10, minor: 3),

            // Both parts can be more than one digit
            ValidExample(raw: "Watch6,18",      type: "Watch",      full: "6,18",  major: 6,  minor: 18),
        ]
    )
    func parsingSplitsValidIdentifiers(example: ValidExample) throws {
        let identifier = try #require(HardwareModelIdentifier(parsing: example.raw))

        #expect(example.type == identifier.type.withoutTypeSafety())
        #expect(example.full == identifier.version.full)
        #expect(example.major == identifier.version.major)
        #expect(example.minor == identifier.version.minor)
    }


    @Test("An identifier parsed from a string equals one built from the same parts")
    func parsedIdentifierEqualsMemberwiseIdentifier() {
        let built = HardwareModelIdentifier(type: "MacBookAir", version: .init(major: 9, minor: 1))

        #expect(built == HardwareModelIdentifier(parsing: "MacBookAir9,1"))
    }


    @Test(
        "`init?(parsing:)` returns `nil` for anything which isn't a type followed by `major,minor`",
        arguments: [
            "",                           // Nothing at all
            "Mac",                        // No version
            "Mac14",                      // No minor version
            "Mac14,",                     // Empty minor version
            "Mac,8",                      // Empty major version
            "MacBookAir9,x",              // Minor version isn't a number
            "MacBookAirx,1",              // Major version isn't a number
            "Mac14,8,1",                  // One version component too many
            "Mac14.8",                    // Wrong separator
            "Mac99999999999999999999,1",  // Major version too big to be an `Int`
            "Mac14,99999999999999999999", // Minor version too big to be an `Int`
        ]
    )
    func parsingRejectsMalformedIdentifiers(raw: String) {
        #expect(nil == HardwareModelIdentifier(parsing: raw))
    }
}
