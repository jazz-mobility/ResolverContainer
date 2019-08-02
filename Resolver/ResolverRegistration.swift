//
//  ResolverRegistration.swift
//  Resolver
//
//  Created by Natan Zalkin on 26/07/2019.
//  Copyright © 2019 Natan Zalkin. All rights reserved.
//

import Foundation

/// A protocol describing registration of specific resolver
public protocol ResolverRegistration {

    /// Registers new resolver of specified type
    func register<T>(resolver: @escaping () -> T)

    /// Unregister resolver associated with specified type
    @discardableResult
    func unregister<T>(_ type: T.Type) -> Bool

}
