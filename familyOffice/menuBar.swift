//
//  menuBar.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 21/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.darkGray
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let cellId = "cellId"
    let array = ["CHATS", "GRUPOS", "MIEMBROS"]
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(collectionView)
        addContraintWithFormat(format: "H:|[v0]|", views: collectionView)
        addContraintWithFormat(format: "V:|[v0]|", views: collectionView)
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        backgroundColor = UIColor.gray
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .bottom )
        setupHorizontalBar()
    }
    var horizontalBarLeftAnchorContraint: NSLayoutConstraint?
    func setupHorizontalBar() -> Void {
        let horizontalView = UIView()
        horizontalView.backgroundColor = UIColor.white
        horizontalView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalView)
        horizontalBarLeftAnchorContraint =  horizontalView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorContraint?.isActive = true
        horizontalView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
        horizontalView.heightAnchor.constraint(equalToConstant: 5).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let x = CGFloat(indexPath.item) * frame.width / 3
        horizontalBarLeftAnchorContraint?.constant = x
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.label.text = array[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/3, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
   
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) No ha sido implementado")
    }
}

class MenuCell: BaseCell {
    let label: UILabel = {
        let lb = UILabel()
        lb.font = lb.font.withSize(12)
        lb.tintColor = UIColor.init(red: 91, green: 14, blue: 13, alpha: 0)
        return lb
    }()
    
    override var isHighlighted: Bool {
        didSet {
            label.textColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    override var isSelected: Bool {
        didSet {
            label.textColor = isSelected ? UIColor.white : UIColor.black
        }
    }
    
    override func setupViews() {
        super.setupViews()
        addSubview(label)
        addContraintWithFormat(format: "H:[v0(60)]", views: label)
        addContraintWithFormat(format: "V:[v0(28)]", views: label)
        
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
