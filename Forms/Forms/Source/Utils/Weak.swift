//
//  Weak.swift
//  Forms
//
//  Created by Konrad on 6/3/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: Weak
public func Weak<T: AnyObject>(_ object: T,
                               _ action: @escaping (T?) -> Void) -> () -> Void {
    return { [weak object] in
        action(object)
    }
}
public func Weak<T: AnyObject, P1>(_ object: T,
                                   _ action: @escaping (T?, P1) -> Void) -> (P1) -> Void {
    return { [weak object] (p1: P1) in
        action(object, p1)
    }
}
public func Weak<T: AnyObject, P1, P2>(_ object: T,
                                       _ action: @escaping (T?, P1, P2) -> Void) -> (P1, P2) -> Void {
    return { [weak object] (p1: P1, p2: P2) in
        action(object, p1, p2)
    }
}
public func Weak<T: AnyObject, P1, P2, P3>(_ object: T,
                                           _ action: @escaping (T?, P1, P2, P3) -> Void) -> (P1, P2, P3) -> Void {
    return { [weak object] (p1: P1, p2: P2, p3: P3) in
        action(object, p1, p2, p3)
    }
}
public func Weak<T: AnyObject, P1, P2, P3, P4>(_ object: T,
                                               _ action: @escaping (T?, P1, P2, P3, P4) -> Void) -> (P1, P2, P3, P4) -> Void {
    return { [weak object] (p1: P1, p2: P2, p3: P3, p4: P4) in
        action(object, p1, p2, p3, p4)
    }
}
public func Weak<T: AnyObject, P1, P2, P3, P4, P5>(_ object: T,
                                                   _ action: @escaping (T?, P1, P2, P3, P4, P5) -> Void) -> (P1, P2, P3, P4, P5) -> Void {
    return { [weak object] (p1: P1, p2: P2, p3: P3, p4: P4, p5: P5) in
        action(object, p1, p2, p3, p4, p5)
    }
}

// MARK: Unowned
public func Unowned<T: AnyObject>(_ object: T,
                                  _ action: @escaping (T) -> Void) -> () -> Void {
    return { [unowned object] in
        action(object)
    }
}
public func Unowned<T: AnyObject, P1>(_ object: T,
                                      _ action: @escaping (T, P1) -> Void) -> (P1) -> Void {
    return { [unowned object] (p1: P1) in
        action(object, p1)
    }
}
public func Unowned<T: AnyObject, P1, P2>(_ object: T,
                                          _ action: @escaping (T, P1, P2) -> Void) -> (P1, P2) -> Void {
    return { [unowned object] (p1: P1, p2: P2) in
        action(object, p1, p2)
    }
}
public func Unowned<T: AnyObject, P1, P2, P3>(_ object: T,
                                              _ action: @escaping (T, P1, P2, P3) -> Void) -> (P1, P2, P3) -> Void {
    return { [unowned object] (p1: P1, p2: P2, p3: P3) in
        action(object, p1, p2, p3)
    }
}
public func Unowned<T: AnyObject, P1, P2, P3, P4>(_ object: T,
                                                  _ action: @escaping (T, P1, P2, P3, P4) -> Void) -> (P1, P2, P3, P4) -> Void {
    return { [unowned object] (p1: P1, p2: P2, p3: P3, p4: P4) in
        action(object, p1, p2, p3, p4)
    }
}
public func Unowned<T: AnyObject, P1, P2, P3, P4, P5>(_ object: T,
                                                      _ action: @escaping (T, P1, P2, P3, P4, P5) -> Void) -> (P1, P2, P3, P4, P5) -> Void {
    return { [unowned object] (p1: P1, p2: P2, p3: P3, p4: P4, p5: P5) in
        action(object, p1, p2, p3, p4, p5)
    }
}

// MARK: Strong
public func Strong<T: AnyObject>(_ object: T,
                                 _ action: @escaping (T) -> Void) -> () -> Void {
    return { [weak object] in
        guard let object = object else { return }
        action(object)
    }
}
public func Strong<T: AnyObject, P1>(_ object: T,
                                     _ action: @escaping (T, P1) -> Void) -> (P1) -> Void {
    return { [weak object] (p1: P1) in
        guard let object = object else { return }
        action(object, p1)
    }
}
public func Strong<T: AnyObject, P1, P2>(_ object: T,
                                         _ action: @escaping (T, P1, P2) -> Void) -> (P1, P2) -> Void {
    return { [weak object] (p1: P1, p2: P2) in
        guard let object = object else { return }
        action(object, p1, p2)
    }
}
public func Strong<T: AnyObject, P1, P2, P3>(_ object: T,
                                             _ action: @escaping (T, P1, P2, P3) -> Void) -> (P1, P2, P3) -> Void {
    return { [weak object] (p1: P1, p2: P2, p3: P3) in
        guard let object = object else { return }
        action(object, p1, p2, p3)
    }
}
public func Strong<T: AnyObject, P1, P2, P3, P4>(_ object: T,
                                                 _ action: @escaping (T, P1, P2, P3, P4) -> Void) -> (P1, P2, P3, P4) -> Void {
    return { [weak object] (p1: P1, p2: P2, p3: P3, p4: P4) in
        guard let object = object else { return }
        action(object, p1, p2, p3, p4)
    }
}
public func Strong<T: AnyObject, P1, P2, P3, P4, P5>(_ object: T,
                                                     _ action: @escaping (T, P1, P2, P3, P4, P5) -> Void) -> (P1, P2, P3, P4, P5) -> Void {
    return { [weak object] (p1: P1, p2: P2, p3: P3, p4: P4, p5: P5) in
        guard let object = object else { return }
        action(object, p1, p2, p3, p4, p5)
    }
}
