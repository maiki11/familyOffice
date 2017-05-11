//
//  menuBar.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 21/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    var chatController : chatCollectionViewController!
    var addEventController : AddEventViewController!
    weak var handleMapSearchDelegate: HandleMenuBar?
    var array : [String]!
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let cellId = "cellMenuId"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(collectionView)
        addContraintWithFormat(format: "H:|[v0]|", views: collectionView)
        addContraintWithFormat(format: "V:|[v0]|", views: collectionView)
        
    }
  
    
    var horizontalBarLeftAnchorContraint: NSLayoutConstraint?
    func setupHorizontalBar() -> Void {
        if array != nil {
            let selectedIndexPath = IndexPath(item: 0, section: 0)
            collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally )
        }
        let horizontalView = UIView()
        horizontalView.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.1764705882, blue: 0.5019607843, alpha: 1)
        horizontalView.translatesAutoresizingMaskIntoConstraints = true
        collectionView.addSubview(horizontalView)
        horizontalBarLeftAnchorContraint =  horizontalView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorContraint?.isActive = true
        horizontalView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: CGFloat(1/array.count)).isActive = true
        horizontalView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
       
        handleMapSearchDelegate?.scrollMenuIndex(indexPath.item)
        
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array != nil ? array.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.label.text = array[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = CGFloat(Int32(array.count))
        return CGSize(width: frame.width/count, height: frame.height)
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
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.textColor =  #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return lb
    }()
    
    override var isHighlighted: Bool {
        didSet {
            label.textColor = isHighlighted ? #colorLiteral(red: 0.2941176471, green: 0.1764705882, blue: 0.5019607843, alpha: 1) : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            
        }
    }
    override var isSelected: Bool {
        didSet {
            label.textColor = isSelected ? #colorLiteral(red: 0.2941176471, green: 0.1764705882, blue: 0.5019607843, alpha: 1) : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
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
