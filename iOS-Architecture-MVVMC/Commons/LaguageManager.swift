//
//  LaguageManager.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/06/22.
//

import Foundation

protocol LanguageManagerSujectType {
    func notifyChangeLaguage(languageCode: String)
}

public protocol LanguageObserver: AnyObject {
    func changeLanguageManager(_ languageCode: String)
}

public protocol LanguageManagerType {
    func changeLanguage(_ languageCode: String)
    func addLanguageObserver(_ observer: LanguageObserver)
    func removeLanguageObserver(_ observer: LanguageObserver)
}

class LanguageManager: LanguageManagerType, LanguageManagerSujectType {
    init() {}

    private struct Observation {
        weak var observer: LanguageObserver?
    }

    private var observers: [Observation] = []

    func addLanguageObserver(_ observer: LanguageObserver) {
        observers = observers.filter({($0.observer != nil && $0.observer !== observer)})
        observers.append(.init(observer: observer))
    }

    func removeLanguageObserver(_ observer: LanguageObserver) {
        observers = observers.filter({($0.observer != nil && $0.observer !== observer)})
    }

    func changeLanguage(_ languageCode: String) {
        notifyChangeLaguage(languageCode: languageCode)
    }

    func notifyChangeLaguage(languageCode: String) {
        observers.forEach { $0.observer?.changeLanguageManager(languageCode) }
    }
}
