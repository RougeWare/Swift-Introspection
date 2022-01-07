[![Tested on GitHub Actions](https://github.com/RougeWare/Swift-Introspection/actions/workflows/swift.yml/badge.svg)](https://github.com/RougeWare/Swift-Introspection/actions/workflows/swift.yml) [![](https://www.codefactor.io/repository/github/rougeware/swift-introspection/badge)](https://www.codefactor.io/repository/github/rougeware/swift-introspection)

[![Swift 5](https://img.shields.io/badge/swift-5.5-brightgreen.svg?logo=swift&logoColor=white)](https://swift.org) [![swift package manager 5.2 is supported](https://img.shields.io/badge/swift%20package%20manager-5.2-brightgreen.svg)](https://swift.org/package-manager) [![Supports macOS, iOS, tvOS, watchOS, Linux, & Windows](https://img.shields.io/badge/macOS%20%7C%20iOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux%20%7C%20Windows-grey.svg)](./Package.swift) 
[![](https://img.shields.io/github/release-date/rougeware/swift-introspection?label=latest%20release)](https://github.com/RougeWare/swift-introspection/releases/latest)



# Introspection #

A Swift package which aides in checking information about the current app, system, & device.



## The app bundle ##

This includes some sugar for reading your app bundle:

```swift
import Introspection

Introspection.bundleId   // The ID of the main bundle, as read from its info dictionary (e.g. `com.acme.MyApp`)
Introspection.appName    // The name of your app, as read from its bundle info
Introspection.appVersion // The semantic version of your app, as read from its bundle info, parsed into a `SemVer` value
```


This package also includes a generic version reader for any bundle:

```swift
import Introspection

Introspection.Bundle.id(of: Bundle(for: SomeClass.self))
Introspection.Bundle.name(of: Bundle(for: SomeClass.self))
Introspection.Bundle.version(of: Bundle(for: SomeClass.self))
```


And makes general bundle access easier:

```swift
import Introspection

let accentColorName: String? = Introspection.Bundle["NSAccentColorName"]
let supportedPlatforms: [String]? = Introspection.Bundle["CFBundleSupportedPlatforms"]
```



## The device ##

This also lets you check info about the current device:

```swift
import Introspection

Introspection.Device.modelType == .iPhone
Introspection.Device.class == .laptop
```
