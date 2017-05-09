//
//  Value.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 09/05/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//
import UIKit
struct Value {
    var title: String!
    var description: String!
    var url: String!
    
    init(title:String, description:String, url:String) {
        self.url = url
        self.description = description
        self.title = title
    }
    
}
protocol ValueBindable: AnyObject {
    var value: Value! {get set}
    var titleLabel: UILabel! {get}
    var descriptionLabel: UILabel! {get}
    var mainImageView: UIImageView! {get}
}
extension ValueBindable {
    var titleLabel : UILabel! {
        return nil
    }
    var descriptionLabel : UILabel! {
        return nil
    }
    var mainImageView : UIImageView! {
        return nil
    }
    
    // Bind
    
    func bind(value: Value) {
        self.value = value
        bind()
    }
    
    func bind() {
        
        guard let value = self.value else {
            return
        }

        if let titleLabel = self.titleLabel {
            titleLabel.text = value.title
        }
        if let descriptionLabel = self.descriptionLabel {
            descriptionLabel.text = value.description
        }
        
        if let mainImageView = self.mainImageView, !value.url.isEmpty {
            mainImageView.loadImage(urlString: value.url)
        }
        
        
    }

    
}
