//
//  FancyCarService.swift
//  FancyCars
//
//  Created by Apple on 2019-09-25.
//  Copyright © 2019 Abdullah. All rights reserved.
//

import Foundation
import RxSwift

typealias CarsHandler = (Result<[Car]>)->Void
typealias AvailHandler = (Result<[Availability]>)->Void
typealias AvailHandlerSingle = (Result<Availability>)->Void

enum CustomError: Error {
    case forcedError
    case noDataFromServer
    case parsing
}

enum Result<T> {
    case success(result: T)
    case fail(CustomError)
}

protocol FancyCarService {
    func getAvailability() -> Observable<[Availability]>
    func getCars() -> Observable<[Car]>
    func getAvailabilitySingle(id: Int) -> Observable<Availability>
}

class FancyCarServiceLocal: FancyCarService {
    private var parser: Parser
    
    init(parser: Parser) {
        self.parser = parser
    }
    
    func getAvailability() -> Observable<[Availability]> {
        return Observable.create { [weak self] observer in
            //if the current class has been removed (Network layer) then that means there should be no observer on the current observable either
            guard let strongSelf = self else {
                observer.onNext([])
                observer.onCompleted()
                return Disposables.create()
            }

            strongSelf.getAvailability() { result in
                switch result {
                case .success(let info):
                    observer.onNext(info)
                    observer.onCompleted()
                case .fail(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create {}
        }
    }
    
    func getAvailabilitySingle(id: Int) -> Observable<Availability> {
        return Observable.create { [weak self] observer in
            //if the current class has been removed (Network layer) then that means there should be no observer on the current observable either
            guard let strongSelf = self else {
                observer.onNext(Availability())
                observer.onCompleted()
                return Disposables.create()
            }
            
            strongSelf.getAvailabilitySingle() { result in
                switch result {
                case .success(let info):
                    observer.onNext(info)
                    observer.onCompleted()
                case .fail(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {}
        }
    }
    
    func getCars() -> Observable<[Car]> {
        return Observable.create { [weak self] observer in
            guard let strongSelf = self else {
                observer.onNext([])
                observer.onCompleted()
                return Disposables.create()
            }
            
            strongSelf.getCars() { result in
                switch result {
                case .success(let info):
                    observer.onNext(info) //push result
                    observer.onCompleted() //finish single unit of work
                case .fail(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {}
        }
    }
    
    /// reads from the local file system
    private func getCars(handler: @escaping CarsHandler) {
        if let url = Bundle.main.url(forResource: "cars", withExtension: "json") {
            do {
                let cars = parser.decode(from: try Data(contentsOf: url), to: [Car].self)
                handler(Result<[Car]>.success(result: cars ?? []))
            } catch {
                handler(Result<[Car]>.fail(CustomError.parsing))
            }
        }
    }
    
    /// reads from the local filesystem
    private func getAvailability(handler: @escaping AvailHandler) {
        if let url = Bundle.main.url(forResource: "availabilities", withExtension: "json") {
            do {
                let avails = parser.decode(from: try Data(contentsOf: url), to: [Availability].self)
                handler(Result<[Availability]>.success(result: avails ?? []))
            } catch {
                handler(Result<[Availability]>.fail(CustomError.parsing))
            }
        }

    }
    
    private func getAvailabilitySingle(handler: @escaping AvailHandlerSingle) {
        if let url = Bundle.main.url(forResource: "availability", withExtension: "json") {
            do {
                let avails = parser.decode(from: try Data(contentsOf: url), to: Availability.self)
                handler(Result<Availability>.success(result: avails ?? Availability()))
            } catch {
                handler(Result<Availability>.fail(CustomError.parsing))
            }
        }
        
    }
}
