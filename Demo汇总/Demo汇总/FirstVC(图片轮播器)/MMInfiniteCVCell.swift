//
//  MMInfiniteCVCell.swift
//  Demo汇总
//
//  Created by yangjie on 2019/8/12.
//  Copyright © 2019 YangJie. All rights reserved.
//

import UIKit


class MMInfiniteCVCell: UICollectionViewCell {
    
    static let InfiniteCellID: String = "MMInfiniteCVCell"
    
    var singleImageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        singleImageView = UIImageView(frame: frame)
        contentView.addSubview(singleImageView!)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        singleImageView?.frame = contentView.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
