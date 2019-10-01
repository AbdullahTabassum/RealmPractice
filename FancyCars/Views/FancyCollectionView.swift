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
import SDWebImage

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
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(FancyCollectionCellView.self, forCellReuseIdentifier: FancyCollectionCellView.identifier)
        return tableView
    }()

    var cartCount: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = "test"
        label.numberOfLines = 0
        return label
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
        
        self.fancyCarViewModel.updateSortOrder(criteria: self.fancyCarViewModel.orderCriterias[0])
    }
    
    private func setupPicker() {
        Observable.just(fancyCarViewModel.orderCriterias).bind(to: pickerView.rx.itemTitles) { _, item in
            return "\(item)"
        }
        .disposed(by: bag)
        
        pickerView.rx.itemSelected.subscribe(onNext: {[weak self] (row, value) in
            let crit = self?.fancyCarViewModel.orderCriterias[row]
            self?.fancyCarViewModel.updateSortOrder(criteria: crit ?? "make")
        }).disposed(by: bag)

    }
    
    private func setUpTableView() {
        self.fancyCarViewModel.fancyCars.asObservable().bind(to: self.tableView.rx.items(cellIdentifier: FancyCollectionCellView.identifier)) { index, model, cell  in
                if let cellNew = cell as? FancyCollectionCellView {
                    /// todo: move this setting code into the cellView class
                    cellNew.availability.text = model.availability
                    cellNew.make.text = model.car.make
                    cellNew.model.text = model.car.model
                    cellNew.name.text = model.name
                    let imageURL = URL(string: model.car.img)!
                    cellNew.carPhoto.sd_setShowActivityIndicatorView(true)
                    cellNew.carPhoto.sd_setIndicatorStyle(.gray)
                    cellNew.carPhoto.sd_setImage(with: imageURL)
                    cellNew.vModel = self.fancyCarViewModel

                } else {
                    print("error casting")
                }
        }.disposed(by: bag)

        self.fancyCarViewModel.cartCount.asObservable().bind(onNext: { [weak self] value in
            print("came here")
            self?.cartCount.text = String(value)
        }).disposed(by: bag)
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

        self.addSubview(cartCount)
        cartCount.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        cartCount.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}

