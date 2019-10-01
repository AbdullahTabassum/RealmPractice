//
//  FancyCollectionCellView.swift
//  FancyCars
//
//  Created by Apple on 2019-09-27.
//  Copyright © 2019 Abdullah. All rights reserved.
//

import Foundation
import UIKit

class FancyCollectionCellView: UITableViewCell {
    static let identifier: String = "FancyCollectionCellView"
    var vModel: FancyCarsViewModel?
    var name: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var make: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var model: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var availability: UILabel = {
        let label = UILabel()
        label.text = "Unavailable"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var carPhoto: UIImageView = {
        let photo:UIImageView = UIImageView()
        photo.backgroundColor = UIColor.red
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.layer.borderColor = UIColor.green.cgColor
        photo.layer.borderWidth = 3
        return photo
    }()

    var buyButton: UIButton = {
        let button:UIButton = UIButton()
        button.backgroundColor = UIColor.blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(style: UITableViewCellStyle, reuseIdentifier: String?, customString: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        applyConstraints()

        buyButton.rx.tap.bind { [weak self] in
            print("button tapped")
            self?.vModel?.updateCartItems()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func applyConstraints() {
        let marginGuide = contentView.layoutMarginsGuide
        self.contentView.addSubview(name)
        name.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 5.0).isActive = true
        name.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 10.0).isActive = true
        
        self.contentView.addSubview(make)
        make.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10.0).isActive = true
        make.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 10.0).isActive = true
        
        self.contentView.addSubview(model)
        model.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10.0).isActive = true
        model.leadingAnchor.constraint(equalTo: make.trailingAnchor, constant: 10.0).isActive = true
        
        self.contentView.addSubview(carPhoto)
        carPhoto.centerXAnchor.constraint(equalTo: marginGuide.centerXAnchor, constant: 0.0).isActive = true
        carPhoto.topAnchor.constraint(equalTo: model.bottomAnchor, constant: 5.0).isActive = true
        carPhoto.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -5.0).isActive = true
        carPhoto.widthAnchor.constraint(equalToConstant: 100).isActive = true
        carPhoto.heightAnchor.constraint(equalToConstant: 100).isActive = true

        self.contentView.addSubview(buyButton)
        buyButton.leadingAnchor.constraint(equalTo: carPhoto.trailingAnchor, constant: 10.0).isActive = true
        buyButton.topAnchor.constraint(equalTo: carPhoto.topAnchor, constant: 0.0).isActive = true
        buyButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        buyButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        self.contentView.addSubview(availability)
        availability.bottomAnchor.constraint(equalTo: carPhoto.bottomAnchor, constant: 0.0).isActive = true
        availability.leadingAnchor.constraint(equalTo: carPhoto.trailingAnchor, constant: 5.0).isActive = true

    }

}
