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

class FancyCarsViewController: UIViewController {
    let bag = DisposeBag()
    var modelManager : ModelManager!
    var vm : FancyCarsViewModel!

    override func loadView() {

        
        
        modelManager = ModelManagerImpl(service: FancyCarServiceLocal(parser: ParserImpl()))
        vm = FancyCarsViewModelImpl(model: modelManager)


    }

    override func viewDidLoad() {
        super.viewDidLoad()

        /// this stuff should be injected
        let screenSize = UIScreen.main.bounds;
        let screenWidth = screenSize.width;
        let screenHeight = screenSize.height;
        let viewSize = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight )

        self.view =  FancyCollectionView(frame: viewSize, viewModel: vm)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

