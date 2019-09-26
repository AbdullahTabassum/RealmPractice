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
    /// TODO: remove this data to another class
    let pickerData = ["name", "availability"]
    
    let pickerView : UIPickerView!
    
    public var tableView : UITableView!
    
    fileprivate var bag = DisposeBag()
    
    weak var delegate : UITableViewDelegate!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    override init( frame: CGRect ) {
        //todo: use injection here
        self.pickerView = UIPickerView()
        self.tableView = UITableView()
        
        super.init(frame: frame)
        
        self.setUpViewLayout()
        
        self.setUpTableView()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    func configure( del : UITableViewDelegate ) {
        
        self.delegate = del
        self.tableView.delegate = self.delegate
    }
    
    private func setUpViewLayout() {
        
        //specifiy the dimensions and positions for the search bar and table view
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pickerView);
        
        self.addConstraint(NSLayoutConstraint(item: pickerView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0.0));
        
        self.addConstraint(NSLayoutConstraint(item: pickerView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.0, constant: 50.0));
        
        self.addConstraint(NSLayoutConstraint(item: pickerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0));
        
        self.addConstraint(NSLayoutConstraint(item: pickerView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0));
        
        //tableView setup
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView(frame: .zero)
        self.addSubview(tableView)
        
        self.addConstraint(NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: pickerView, attribute: .bottom, multiplier: 1.0, constant: 0.0));
        
        self.addConstraint(NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0));
        
        self.addConstraint(NSLayoutConstraint(item: tableView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0.0));
        
        self.addConstraint(NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: -70.0 ));
        
    }
    
    func setUpTableView() {
        
        //register a table view cell
        //RepoTableCell.register(with: tableView)
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.delegate = self.delegate
        
    }
    
}

extension FancyCollectionView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        self.txt_pickUpData.text = pickerData[row]
//    }
}

