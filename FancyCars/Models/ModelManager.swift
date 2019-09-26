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
    
    var bag : DisposeBag = DisposeBag();
    
    var carsService : FancyCarService
    
    init(service : FancyCarService) {
        self.carsService = service
    }
    
    //func loadCars(finished : @escaping GetRepos) {
    func loadCars() {
        print("calling getRepos!!")
//        self.carsService.getCars().map({ (cars:[Car]) -> [Car] in
//            return cars
//        }).flatMap({ (cars: [Car]) -> (Observable<[Car]>) in
//            return cars.flatMap({ (car: Car) -> Observable<Car> in
//                return self.carsService.getAvailabilitySingle(id: car.id).map({ (a: Availability) -> Car in
//                    car.make = a.available
//                    return car
//                })
//            }).toArray()
//        })
        
        
        
        /// todo: make sure we are on a background thread
        Observable.zip(self.carsService.getCars(), self.carsService.getAvailability()) {
            return ($0, $1)
        }.subscribe(
            onNext: { [weak self] (cars, avails) in
                print(cars)
                print(avails)
                /// update the Realm DataBase with these objects
                let realm = try! Realm()
                try! realm.write {
                    realm.add(cars, update: true)
                    realm.add(avails, update: true)
                }
            },
            onError: { error in
                print("\(error.localizedDescription)")
            }
        ).disposed(by: bag)
        
        
//        self.carsService.getCars().subscribe(
//            onNext : { [weak self] cars in
//                print(cars)
//            },
//            onError: { error in
//                print("\(error.localizedDescription)")
//            }
//        ).disposed(by: bag)
    }
    
    func getSortedCars(sortOrder: String) -> Observable<(AnyRealmCollection<Car>, RealmChangeset?)> {
        //let resultsBag = DisposeBag()
        let realm = try! Realm()
        let repos = realm.objects(Car.self).sorted(byKeyPath: sortOrder, ascending: false)
        return Observable.changeset(from:repos)
    }
}
