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
    var cartCount: Variable<Int>{get set}
    var orderCriterias: [String]{get}
    func updateCartItems()
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

    private var count = 0
    
    init(model: ModelManager) {
        modelManager = model
        //modelManager.loadCars()
    }
    
    let orderCriterias = ["Name", "Availability"]
    
    private let orderCriteriaKeyPaths: [String: KeyPath<FancyCars, String>] = ["Name": \FancyCars.name, "Availability":\FancyCars.availability]

    var fancyCars: Variable<[FancyCars]> = Variable<[FancyCars]>([])
    var cartCount: Variable<Int> = Variable<Int>(0)
    
    func updateSortOrder(criteria: String) {
        /// was initially aiming to do the sorting in the model with Realm, but it seems to be broken
        /// so i am sorting the data in the view model here below
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

    func updateCartItems() {
        self.cartCount.value = self.cartCount.value + 1
    }

}


