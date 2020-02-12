//
//  WeatherSearchView.swift
//  WeatherApp January 31st
//
//  Created by Margiett Gil on 1/31/20.
//  Copyright © 2020 Margiett Gil. All rights reserved.
//

import UIKit

class WeatherSearchView: UIView {
    
        
    public var cityNameLabel: UILabel = {
        let label = UILabel()
        label.text = "The Weather channel"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    public var summaryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    public var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionViewPro = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return collectionViewPro
    }()
    
    public var textField: UITextField = {
        let ziptext = UITextField()
        ziptext.backgroundColor = .purple
        ziptext.placeholder = "enter your zipcode here"
        ziptext.textAlignment = .center
        ziptext.keyboardType = .numbersAndPunctuation
        return ziptext
    }()

    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func commonInit() {
        setupCityLabelConstraints()
        setupSummaryLabelConstraints()
        setupCollectionViewConstraints()
        setupZiptextConstraints()
    }
    
    
    private func setupCityLabelConstraints() {
        addSubview(cityNameLabel)
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            cityNameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            cityNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cityNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            
        ])
    }
    private func setupCollectionViewConstraints() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
             collectionView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            collectionView.heightAnchor.constraint(equalToConstant: 300)
           
        ])
    }
    
    private func setupSummaryLabelConstraints() {
        addSubview(summaryLabel)
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            summaryLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 20),
            summaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            summaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        
        ])
    }
    
    private func setupZiptextConstraints() {
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -100),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }


}

