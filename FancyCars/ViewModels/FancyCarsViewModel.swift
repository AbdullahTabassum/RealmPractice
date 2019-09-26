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
}

struct FancyCars {
    init(car: Car) {
        self.car = car
    }
    var car: Car
    var isAvailable: Bool {
        return car.availability?.available == "Available"
    }
}

class FancyCarsViewModelImpl: FancyCarsViewModel {
    var bag : DisposeBag = DisposeBag();
    var modelManager: ModelManager
    
    init(model: ModelManager) {
        modelManager = model
        modelManager.loadCars()
    }
    
    static let orderCriterias = ["name", "make", "model", "year"]

    var fancyCars : Variable<[FancyCars]> = Variable<[FancyCars]>([])

    func updateSortOrder(criteria: String) {
        /// get availabity for each one
        modelManager.getSortedCars(sortOrder: criteria)
            .subscribe(
                onNext: { [weak self] results, changes in
                    print("we came here 1")
                    print(results)
                    print(changes)
                    print("we came here 2")
                    self?.fancyCars.value = [FancyCars(car: Car())]
                    
            }).disposed(by: bag)
    }
}
