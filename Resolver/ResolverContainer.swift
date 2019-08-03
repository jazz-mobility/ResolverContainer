//
//  ResolverContainer.swift
//  Resolver
//
//  Created by Natan Zalkin on 26/07/2019.
//  Copyright © 2019 Natan Zalkin. All rights reserved.
//

/*
* Copyright (c) 2019 Natan Zalkin
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
*/

import Foundation

/// Thread safe container allowing to register and extract resolvers
public class ResolverContainer {

    enum Error: Swift.Error {
        case unregisteredType(String)
        case typeMismatch(expected: String)
    }

    private var entries = [ObjectIdentifier: () -> Any]()
    private var syncQueue = DispatchQueue(label: "ResolverContainer.SyncQueue")

    public init(registration: ((ResolverContainer) -> Void)? = nil) {
        defer {
            registration?(self)
        }
    }

}

extension ResolverContainer: ResolverRegistering {

    public func register<T>(resolver: @escaping () -> T) {
        syncQueue.sync { entries[ObjectIdentifier(T.self)] = resolver }
    }

    @discardableResult
    public func unregister<T>(_ type: T.Type) -> Bool {
        return syncQueue.sync { entries.removeValue(forKey: ObjectIdentifier(T.self)) != nil }
    }

}

extension ResolverContainer: InstanceResolving {

    public func resolve<T>(_ type: T.Type) throws -> T {

        guard let resolver = syncQueue.sync(execute: { entries[ObjectIdentifier(T.self)] }) else {
            throw Error.unregisteredType(String(describing: T.self))
        }

        guard let entry = resolver() as? T else {
            throw Error.typeMismatch(expected: String(describing: T.self))
        }

        return entry
    }

}
