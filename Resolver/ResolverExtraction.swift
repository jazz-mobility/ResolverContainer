//
//  ResolverExtraction.swift
//  Resolver
//
//  Created by Natan Zalkin on 26/07/2019.
//  Copyright © 2019 Natan Zalkin. All rights reserved.
//

import Foundation

/// A protocol describing resolving of instance or metatype
public protocol ResolverExtraction {

    /// Try to resolve instance or metatype assosiated with its metatype designator. Throws error if no sutable resolver found
    func resolve<T>(_ type: T.Type) throws -> T

}

public extension ResolverExtraction {

    /// Try to resolve instance or metatype assosiated with its metatype designator. Throws error if no sutable resolver found
    func resolve<T>() throws -> T {
        return try resolve(T.self)
    }
    
}
