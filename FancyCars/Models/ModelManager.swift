//
//  ModelManager.swift
//  FancyCars
//
//  Created by Apple on 2019-09-25.
//  Copyright © 2019 Abdullah. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm

typealias GetRepos = ([Car]) -> Void

protocol ModelManager {
    func loadCars()
    func getSortedCars(sortOrder: String) -> Observable<(AnyRealmCollection<Car>, RealmChangeset?)> 
}

class ModelManagerImpl : ModelManager{

    /// as we don't want to create new observables every time, we cache observables and store them by sort priority
    private var changeSetObservables: [String: Observable<(AnyRealmCollection<Car>, RealmChangeset?)>] = [:]
    
    var bag : DisposeBag = DisposeBag();
    
    var carsService : FancyCarService
    
    init(service : FancyCarService) {
        self.carsService = service
    }
    
    //func loadCars(finished : @escaping GetRepos) {
    func loadCars() {
        /// this only gets called once so we don't have to worry about large amount of observables remaining in  DisposeBag
        self.carsService.getCars().map({ (cars:[Car]) -> [Car] in
            return cars
        }).flatMap({ (cars: [Car]) -> (Observable<[Car]>) in
            return Observable.from(cars).flatMap({ (car: Car) -> Observable<Car> in
                print("came inside of the second flat map")
                return self.carsService.getAvailabilitySingle(id: car.id).flatMap({(av: Availability) -> (Observable<Car>) in
                    car.availability = av
                    return Observable.just(car)
                })
            }).toArray()
        }).subscribe(
            onNext : { [weak self] cars in
                print(cars)
                self?.insertCarsIntoDB(cars: cars)
            },
            onError: { error in
                print("\(error.localizedDescription)")
            }
        ).disposed(by: bag)

        /// todo: make sure we are on a background thread
//        Observable.zip(self.carsService.getCars(), self.carsService.getAvailability()) {
//            return ($0, $1)
//        }.subscribe(
//            onNext: { [weak self] (cars, avails) in
//                print(cars)
//                print(avails)
//                /// update the Realm DataBase with these objects
//                let realm = try! Realm()
//                try! realm.write {
//                    realm.add(cars, update: true)
//                    realm.add(avails, update: true)
//                }
//            },
//            onError: { error in
//                print("\(error.localizedDescription)")
//            }
//        ).disposed(by: bag)

    }

    private func insertCarsIntoDB(cars: [Car]) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(cars, update: true)
        }
    }
    
    func getSortedCars(sortOrder: String) -> Observable<(AnyRealmCollection<Car>, RealmChangeset?)> {
        /// we should reuse observables if they have already been created
        ///sorting with realm api is not working, so will handle sorting in the view model
        let overrideSortOrder = "name"
        if let result = changeSetObservables[overrideSortOrder] {
            return result.share(replay: 1)
        } else {
            let realm = try! Realm()
            let cars = realm.objects(Car.self).sorted(byKeyPath: overrideSortOrder, ascending: true)
            let ret = Observable.changeset(from:cars).share(replay: 1)
            changeSetObservables[sortOrder] = ret
            return ret
        }
    }
}
