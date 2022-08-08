//
//  Observable.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 25/05/2022.
//

import Foundation

public final class Observable<Value> {
    struct Observer<Value> {
        weak var observer: AnyObject?
        let block: (Value?) -> Void
    }

    private var observers = [Observer<Value>]()

    public var value: Value? {
        didSet { notifyObservers(value: value) }
    }

    public init(_ value: Value? = nil) {
        self.value = value
    }

    public func observe(on observer: AnyObject, observerBlock: @escaping (Value?) -> Void) {
        observers.append(Observer(observer: observer, block: observerBlock))
        observerBlock(self.value)
    }

    public func sink(on observer: AnyObject, observerBlock: @escaping (Value?) -> Void) -> Self {
        observers.append(Observer(observer: observer, block: observerBlock))
        observerBlock(value)
        return self
    }

    public func remove(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }

    private func notifyObservers(value: Value?) {
        for observer in observers {
            DispatchQueue.main.async { observer.block(value) }
        }
    }
}
