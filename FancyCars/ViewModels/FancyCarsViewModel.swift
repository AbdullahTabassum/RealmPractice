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
    func getCarCollection()
    func updateSortOrder(criteria: String)
}


class FancyCarsViewModelImpl: FancyCarsViewModel {
    var bag : DisposeBag = DisposeBag();
    var modelManager: ModelManager
    
    init(model: ModelManager) {
        modelManager = model
    }
    
    static let orderCriterias = ["name", "make", "model", "year"]
    
    struct FancyCars {
        var car: Car
        private var availability: Availability
        var isAvailable: Bool {
            return availability.available == "Available"
        }
    }
    
    var cars : Variable<[FancyCars]> = Variable<[FancyCars]>([])
    
    func getCarCollection() {
        /// trigger the
        modelManager.loadCars()
    }
    
    func updateSortOrder(criteria: String) {
        /// get availabity for each one
        modelManager.getSortedCars(sortOrder: criteria)
            .subscribe(
                onNext: { [weak self] results, changes in
                    print("we came here 1")
                    let test = 45
                    print("we came here 2")
                    //print(results)
                    //print(changes)
                    
            }).disposed(by: bag)
    }
}
