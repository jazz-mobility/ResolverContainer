//
//  ResolvingContainer.swift
//  Resolver
//
//  Created by Natan Zalkin on 26/07/2019.
//  Copyright © 2019 Natan Zalkin. All rights reserved.
//

import Foundation

/// Thread safe container allowing to register and extract resolvers
public class ResolvingContainer {

    enum Error: Swift.Error {
        case unregisteredType(String)
        case typeMismatch(expected: String)
    }

    private var entries = [ObjectIdentifier: () -> Any]()
    private var syncQueue = DispatchQueue(label: "ResolvingContainer.SyncQueue")

    public init(registration: ((ResolvingContainer) -> Void)? = nil) {
        defer {
            registration?(self)
        }
    }

}

extension ResolvingContainer: ResolverRegistration {

    public func register<T>(resolver: @escaping () -> T) {
        syncQueue.sync { entries[ObjectIdentifier(T.self)] = resolver }
    }

    @discardableResult
    public func unregister<T>(_ type: T.Type) -> Bool {
        return syncQueue.sync { entries.removeValue(forKey: ObjectIdentifier(T.self)) != nil }
    }

}

extension ResolvingContainer: ResolverExtraction {

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
