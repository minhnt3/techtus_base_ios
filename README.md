# Template iOS App using Clean Architecture and MVVM-C
## Overview Detail
![Alt text](README_FILES/CleanArchitect+MVVM-C.png?raw=true "Clean Architecture Layers")
## Layers
* **Domain Layer** = Entities + Use Cases + Repositories Interfaces
* **Data Repositories Layer** = Repositories Implementations + API (Network)
* **Presentation Layer (MVVM)** = ViewModels + Views
* **Others:**
* **Resource** = Images + Colors + Strings + ...
* **Application** = AppDelegate + DI + Coordinator
## Requirements
- Xcode Version 12.0+  Swift 5.0+
## Install
Run 
```ruby 
pod install
```
## Config Enviroment
- [Development.xcconfig](iOS-Architecture-MVVMC/Environment/Configs/Development.xcconfig)
- [Qa.xcconfig](iOS-Architecture-MVVMC/Environment/Configs/Qa.xcconfig)
- [Staging.xcconfig](iOS-Architecture-MVVMC/Environment/Configs/Staging.xcconfig)
- [Production.xcconfig](iOS-Architecture-MVVMC/Environment/Configs/Production.xcconfig)
## Config Firebase
Parse your config to:

- [Development](iOS-Architecture-MVVMC/Environment/GoogleServices/Dev)
- [Qa](iOS-Architecture-MVVMC/Environment/GoogleServices/Qa)
- [Staging](iOS-Architecture-MVVMC/Environment/GoogleServices/Stag)
- [Production](iOS-Architecture-MVVMC/Environment/GoogleServices/Production)
## How to use lib, common at template
* [Readme Common](README_COMMON.md)
## Naming convention
* [Readme naming convention](README_NAMING_CONVENTIONS.md)
