//
//  LocalDatabaseService.swift
//  iOS-Architecture-MVVMC
//
//  Created by datlt on 29/06/2022.
//

import Foundation
import RealmSwift

protocol LocalDbMapper {
    associatedtype LocalObjectType
    associatedtype AppObjectType

    func mapToAppObject(_ object: LocalObjectType) -> AppObjectType
    func mapToAppObjects(_ objects: [LocalObjectType]) -> [AppObjectType]
    func mapToLocalObject(_ appObject: AppObjectType) -> LocalObjectType
    func mapToLocalObjects(_ appObjects: [AppObjectType]) -> [LocalObjectType]
}

protocol LocalDatabaseService {
    /// Create object asynchronously.
    func create<Mapper>(_ object: Mapper.AppObjectType,
                        withMapper mapper: Mapper,
                        completion: @escaping (Result<Void, LocalError>) -> Void) where Mapper: LocalDbMapper
    /// Create objects asynchronously.
    func create<Mapper>(_ objects: [Mapper.AppObjectType],
                        withMapper mapper: Mapper,
                        completion: @escaping (Result<Void, LocalError>) -> Void) where Mapper: LocalDbMapper
    func find<KeyType, Mapper>(primaryKey: KeyType,
                               mapper: Mapper,
                               completion: @escaping (Mapper.AppObjectType?) -> Void) where Mapper: LocalDbMapper
    func find<Mapper>(withMapper mapper: Mapper,
                      completion: @escaping ([Mapper.AppObjectType]?) -> Void) where Mapper: LocalDbMapper
    func find<Mapper>(withMapper mapper: Mapper,
                      predicate: NSPredicate,
                      completion: @escaping ([Mapper.AppObjectType]?) -> Void) where Mapper: LocalDbMapper
    /// Update asynchronously.
    func update<Mapper, KeyType>(_ value: Any,
                                 forKey key: String,
                                 primaryKey: KeyType,
                                 mapper: Mapper,
                                 completion: @escaping (Result<Void, LocalError>) -> Void) where Mapper: LocalDbMapper
    /// Update asynchronously.
    func update<Mapper>(_ valuesForKeys: [String: Any],
                        predicate: NSPredicate?,
                        mapper: Mapper,
                        completion: @escaping (Result<Void, LocalError>) -> Void) where Mapper: LocalDbMapper
    /// Delete asynchronously.
    func delete<Mapper, KeyType>(primaryKey: KeyType,
                                 withMapper mapper: Mapper,
                                 completion: @escaping (Result<Void, LocalError>) -> Void) where Mapper: LocalDbMapper
    /// Delete asynchronously.
    func delete<Mapper>(withMapper mapper: Mapper,
                        predicate: NSPredicate?,
                        completion: @escaping (Result<Void, LocalError>) -> Void) where Mapper: LocalDbMapper
    func isExisting<Mapper, KeyType>(withMapper mapper: Mapper,
                                     primaryKey: KeyType,
                                     completion: @escaping (Bool) -> Void) where Mapper: LocalDbMapper
}
