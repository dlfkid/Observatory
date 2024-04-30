//
//  File.swift
//  
//
//  Created by Ravendeng on 2024/4/30.
//

import Foundation

public protocol ObservatoryWrapperable: AnyObject { }

/// The real value holder of `ObservatoryWrapperable`
public struct ObservatoryWrapper<T> {
    var value: T
    init(_ value: T) {
        self.value = value
    }
}

public extension ObservatoryWrapperable {
    var obs: ObservatoryWrapper<Self> {
        get { return ObservatoryWrapper(self) }
        set {}
    }
    
    static var obs: ObservatoryWrapper<Self>.Type {
        get { return ObservatoryWrapper<Self>.self }
        set { }
    }
}
