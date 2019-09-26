//
//  ViewController.swift
//  FancyCars
//
//  Created by Apple on 2019-09-25.
//  Copyright © 2019 Abdullah. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift
import RxRealm

class ViewController: UIViewController {
    
    override func loadView() {
        let screenSize = UIScreen.main.bounds;
        let screenWidth = screenSize.width;
        let screenHeight = screenSize.height;
        let viewSize = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight )
        
        self.view =  FancyCollectionView( frame: viewSize )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let test = ModelManagerImpl(service: FancyCarServiceLocal(parser: ParserImpl()))
        test.loadCars()
        
//        let resultsBag = DisposeBag()
//        let realm = try! Realm()
//        let repos = realm.objects(Car.self).sorted(byKeyPath: "make", ascending: false)
//
//        Observable.changeset(from: repos)
//            .subscribe(onNext: { [weak self] results, changes in
//                //guard let tableView = self?.tableView else { return }
//                print("we came here 1")
//                let test = 45
//                print("we came here 2")
//                //print(results)
//                //print(changes)
//            }).disposed(by: resultsBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

