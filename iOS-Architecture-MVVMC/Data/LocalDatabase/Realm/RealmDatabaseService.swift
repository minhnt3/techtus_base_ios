//
//  RealmDatabaseService.swift
//  iOS-Architecture-MVVMC
//
//  Created by datlt on 30/06/2022.
//

import Foundation
import RealmSwift

class RealmDatabaseService: LocalDatabaseService {
    typealias LocalObjectType = RealmSwift.Object

    private let queue = DispatchQueue(label: "RealmDatabaseServiceQueue")
    private let realm: Realm

    init?() {
        guard let realm = try? Realm() else { return nil }
        self.realm = realm
    }

    func create<Mapper>(_ object: Mapper.AppObjectType,
                        withMapper mapper: Mapper,
                        completion: @escaping (Result<Void, LocalError>) -> Void) where Mapper: LocalDbMapper {
        guard Mapper.LocalObjectType.self is RealmSwift.Object.Type else {
            fatalError("'LocalObjectType' must be 'RealmSwiftObject'")
        }

        let object = mapper.mapToLocalObject(object) as! RealmSwift.Object

        realm.writeAsync({ [weak self] in
            self?.realm.add(object)
        }, onComplete: { error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(LocalDbErrorMapper().map(error)))
                }
            } else {
                DispatchQueue.main.async { completion(.success(())) }
            }
        })
    }

    func create<Mapper>(_ objects: [Mapper.AppObjectType],
                        withMapper mapper: Mapper,
                        completion: @escaping (Result<Void, LocalError>) -> Void) where Mapper: LocalDbMapper {
        guard Mapper.LocalObjectType.self is RealmSwift.Object.Type else {
            fatalError("'LocalObjectType' must be 'RealmSwiftObject'")
        }

        let objects = mapper.mapToLocalObjects(objects) as! [RealmSwift.Object]

        realm.writeAsync({ [weak self] in
            self?.realm.add(objects)
        }, onComplete: { error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(LocalDbErrorMapper().map(error)))
                }
            } else {
                DispatchQueue.main.async { completion(.success(())) }
            }
        })
    }

    func find<KeyType, Mapper>(primaryKey: KeyType,
                               mapper: Mapper,
                               completion: @escaping (Mapper.AppObjectType?) -> Void) where Mapper: LocalDbMapper {
        guard Mapper.LocalObjectType.self is RealmSwift.Object.Type else {
            fatalError("'LocalObjectType' must be 'RealmSwiftObject'")
        }

        let object = realm.object(ofType: Mapper.LocalObjectType.self as! RealmSwift.Object.Type,
                                  forPrimaryKey: primaryKey)

        if let object = object {
            let result = mapper.mapToAppObject(object as! Mapper.LocalObjectType)
            DispatchQueue.main.async { completion(result) }
        } else {
            DispatchQueue.main.async { completion(nil) }
        }
    }

    func find<Mapper>(withMapper mapper: Mapper,
                      completion: @escaping ([Mapper.AppObjectType]?) -> Void) where Mapper: LocalDbMapper {
        guard Mapper.LocalObjectType.self is RealmSwift.Object.Type else {
            fatalError("'LocalObjectType' must be 'RealmSwiftObject'")
        }

        let objects = realm.objects(Mapper.LocalObjectType.self as! RealmSwift.Object.Type)

        var results: [Mapper.AppObjectType] = []
        objects.forEach({ object in
            let result = mapper.mapToAppObject(object as! Mapper.LocalObjectType)
            results.append(result)
        })

        DispatchQueue.main.async { completion(results) }
    }

    func find<Mapper>(withMapper mapper: Mapper,
                      predicate: NSPredicate,
                      completion: @escaping ([Mapper.AppObjectType]?) -> Void) where Mapper: LocalDbMapper {
        guard Mapper.LocalObjectType.self is RealmSwift.Object.Type else {
            fatalError("'LocalObjectType' must be 'RealmSwiftObject'")
        }

        let objects = realm
            .objects(Mapper.LocalObjectType.self as! RealmSwift.Object.Type)
            .filter(predicate)

        var results: [Mapper.AppObjectType] = []
        objects.forEach({ object in
            let result = mapper.mapToAppObject(object as! Mapper.LocalObjectType)
            results.append(result)
        })

        DispatchQueue.main.async { completion(results) }
    }

    func update<Mapper, KeyType>(_ value: Any,
                                 forKey key: String,
                                 primaryKey: KeyType,
                                 mapper: Mapper,
                                 completion: @escaping (Result<Void, LocalError>) -> Void) where Mapper: LocalDbMapper {
        guard Mapper.LocalObjectType.self is RealmSwift.Object.Type else {
            fatalError("'LocalObjectType' must be 'RealmSwiftObject'")
        }

        let object = realm.object(ofType: Mapper.LocalObjectType.self as! RealmSwift.Object.Type,
                                  forPrimaryKey: primaryKey)

        guard let object = object else {
            completion(.success(()))
            return
        }

        realm.writeAsync({
            object.setValue(value, forKey: key)
        }, onComplete: { error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(LocalDbErrorMapper().map(error)))
                }
            } else {
                DispatchQueue.main.async { completion(.success(())) }
            }
        })
    }

    func update<Mapper>(_ valuesForKeys: [String: Any],
                        predicate: NSPredicate?,
                        mapper: Mapper,
                        completion: @escaping (Result<Void, LocalError>) -> Void) where Mapper: LocalDbMapper {
        guard Mapper.LocalObjectType.self is RealmSwift.Object.Type else {
            fatalError("'LocalObjectType' must be 'RealmSwiftObject'")
        }

        var objects = realm.objects(Mapper.LocalObjectType.self as! RealmSwift.Object.Type)

        if let predicate = predicate {
            objects = objects.filter(predicate)
        }

        realm.writeAsync({
            objects.forEach({ object in
                object.setValuesForKeys(valuesForKeys)
            })
        }, onComplete: { error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(LocalDbErrorMapper().map(error)))
                }
            } else {
                DispatchQueue.main.async { completion(.success(())) }
            }
        })
    }

    func delete<Mapper, KeyType>(primaryKey: KeyType,
                                 withMapper mapper: Mapper,
                                 completion: @escaping (Result<Void, LocalError>) -> Void) where Mapper: LocalDbMapper {
        guard Mapper.LocalObjectType.self is RealmSwift.Object.Type else {
            fatalError("'LocalObjectType' must be 'RealmSwiftObject'")
        }

        let object = realm.object(ofType: Mapper.LocalObjectType.self as! RealmSwift.Object.Type,
                                  forPrimaryKey: primaryKey)

        guard let object = object else {
            completion(.success(()))
            return
        }

        realm.writeAsync({ [weak self] in
            self?.realm.delete(object)
        }, onComplete: { error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(LocalDbErrorMapper().map(error)))
                }
            } else {
                DispatchQueue.main.async { completion(.success(())) }
            }
        })
    }

    func delete<Mapper>(withMapper mapper: Mapper,
                        predicate: NSPredicate?,
                        completion: @escaping (Result<Void, LocalError>) -> Void) where Mapper: LocalDbMapper {
        guard Mapper.LocalObjectType.self is RealmSwift.Object.Type else {
            fatalError("'LocalObjectType' must be 'RealmSwiftObject'")
        }

        var objects = realm.objects(Mapper.LocalObjectType.self as! RealmSwift.Object.Type)

        if let predicate = predicate {
            objects = objects.filter(predicate)
        }

        realm.writeAsync({ [weak self] in
            self?.realm.delete(objects)
        }, onComplete: { error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(LocalDbErrorMapper().map(error)))
                }
            } else {
                DispatchQueue.main.async { completion(.success(())) }
            }
        })
    }

    func isExisting<Mapper, KeyType>(withMapper mapper: Mapper,
                                     primaryKey: KeyType,
                                     completion: @escaping (Bool) -> Void) where Mapper: LocalDbMapper {
        guard Mapper.LocalObjectType.self is RealmSwift.Object.Type else {
            fatalError("'LocalObjectType' must be 'RealmSwiftObject'")
        }

        let object = realm.object(ofType: Mapper.LocalObjectType.self as! RealmSwift.Object.Type,
                                  forPrimaryKey: primaryKey)
        DispatchQueue.main.async { completion(object != nil) }
    }
}
