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
    let bag = DisposeBag()
    var modelManager : ModelManager!
    var vm : FancyCarsViewModel!

    override func loadView() {
        let screenSize = UIScreen.main.bounds;
        let screenWidth = screenSize.width;
        let screenHeight = screenSize.height;
        let viewSize = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight )
        
        modelManager = ModelManagerImpl(service: FancyCarServiceLocal(parser: ParserImpl()))
        vm = FancyCarsViewModelImpl(model: modelManager)
        
        self.view =  FancyCollectionView(frame: viewSize, viewModel: vm)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        /// TODO: make sure its on the main thread here
//        vm.fancyCars.asObservable().subscribe(
//            onNext:{ [weak self] fcs in
//                print("ViewController, here are the fancyCars: ")
//                print(fcs)
//            }).disposed(by: bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

