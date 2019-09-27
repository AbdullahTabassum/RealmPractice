//
//  FancyCollectionView.swift
//  FancyCars
//
//  Created by Apple on 2019-09-26.
//  Copyright © 2019 Abdullah. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class FancyCollectionView: UIView {
    private var fancyCarViewModel: FancyCarsViewModel
    fileprivate var bag = DisposeBag()
    
    public var pickerObservable: Observable<(row: Int, component: Int)> {
        return pickerView.rx.itemSelected.share(replay: 1)
    }
    
    let pickerView : UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = UIColor.brown
        return pickerView
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = 100
        tableView.register(FancyCollectionCellView.self, forCellReuseIdentifier: FancyCollectionCellView.identifier)
        return tableView
    }()

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    init( frame: CGRect, viewModel: FancyCarsViewModel ) {
        /// todo: shold use injection here
        fancyCarViewModel = viewModel
        super.init(frame: frame)
        
        self.setUpViewLayout()
        self.setupPicker()
        self.setUpTableView()
    }
    
    private func setupPicker() {
        Observable.just(fancyCarViewModel.orderCriterias).bind(to: pickerView.rx.itemTitles) { _, item in
            return "\(item)"
        }
        
        pickerView.rx.itemSelected.subscribe(onNext: {[weak self] (row, value) in
            NSLog("selected: \(row)")
            let crit = self?.fancyCarViewModel.orderCriterias[row]
            self?.fancyCarViewModel.updateSortOrder(criteria: crit ?? "make")
        }).disposed(by: bag)
    }
    
    private func setUpTableView() {
        self.fancyCarViewModel.fancyCars.asObservable().bind(to: self.tableView.rx.items(cellIdentifier: FancyCollectionCellView.identifier)) { index, model, cell  in
                if let cellNew = cell as? FancyCollectionCellView {
                    cellNew.textLabel?.text = model.name
                } else {
                    print("error casting")
                }
        }.disposed(by: bag)
    }
    
    private func setUpViewLayout() {
        self.addSubview(pickerView);
        pickerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true

        self.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: pickerView.topAnchor).isActive = true
    }
}

