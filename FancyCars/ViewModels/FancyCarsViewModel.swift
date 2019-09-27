//
//  FancyCarsViewModel.swift
//  FancyCars
//
//  Created by Apple on 2019-09-25.
//  Copyright © 2019 Abdullah. All rights reserved.
//

import Foundation
import RxSwift

protocol FancyCarsViewModel {
    func updateSortOrder(criteria: String)
    var fancyCars: Variable<[FancyCars]>{get set}
    var orderCriterias: [String]{get}
}

public extension Sequence {
    func sortKP<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted { a, b in
            return a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
}

struct FancyCars {
    init(car: Car) {
        self.car = car
    }
    var car: Car
    var isAvailable: Bool {
        return car.availability?.available == "Available"
    }
    var availability: String {
        return self.car.availability?.available ?? "Unavailable"
    }
    
    var name: String {
        return car.name
    }
}

class FancyCarsViewModelImpl: FancyCarsViewModel {
    var bag : DisposeBag = DisposeBag();
    var modelManager: ModelManager
    
    init(model: ModelManager) {
        modelManager = model
        modelManager.loadCars()
    }
    
    let orderCriterias = ["name", "availability"]
    
    private let orderCriteriaKeyPaths: [String: KeyPath<FancyCars, String>] = ["name": \FancyCars.name, "availability":\FancyCars.availability]

    var fancyCars : Variable<[FancyCars]> = Variable<[FancyCars]>([])
    
    func updateSortOrder(criteria: String) {
        

        modelManager.getSortedCars(sortOrder: criteria)
            .subscribe(
                onNext: { [weak self] results, changes in
                    guard let fcs = results.realm?.objects(Car.self)
                        .toArray()
                        .map({ return FancyCars(car:$0)})
                        .sortKP(by: (self?.orderCriteriaKeyPaths[criteria])!) else {
                            print("didn't update")
                            return
                    }
                    self?.fancyCars.value = fcs
            }).disposed(by: bag)
    }
}


