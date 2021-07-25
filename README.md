# Introspection #

A Swift package which aides in checking information about the current app, system, & device.



## The app bundle ##

This includes some sugar for reading your app bundle:

```swift
import Introspection

Introspection.appVersion // The semantic version of your app, as read from its bundle info, parsed into a `SemVer` value 
```


This package also includes a generic version reader for any bundle:

```swift
import Introspection

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
