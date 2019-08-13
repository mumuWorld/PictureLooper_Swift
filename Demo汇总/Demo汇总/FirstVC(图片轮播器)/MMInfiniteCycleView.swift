//
//  MMInfiniteCycleView.swift
//  Demo汇总
//
//  Created by yangjie on 2019/8/12.
//  Copyright © 2019 YangJie. All rights reserved.
//

import UIKit
import Kingfisher

enum MMInfiniteDirection {
    case Horizontal,Vertical
}

class MMInfiniteCycleView: UIView {

    var collectionView: UICollectionView?
    
    //尝试下用section
    var itemSectionCount: Int = 128
    
    /// 重复时间
    var tInfiniteTime: Double = 2.0
    
    var sourceImgArr: [String]?
    
    var placeHolderImg: UIImage?
    
    var cellContentMode: UIView.ContentMode = UIView.ContentMode.scaleToFill
    
    var scrollDirection: UICollectionView.ScrollDirection = UICollectionView.ScrollDirection.horizontal
    
    var itemMaxSectionCount: Int {
        get {
            if let tmpArr = sourceImgArr {
                if isNeedInfinite {
                    return tmpArr.count * itemSectionCount
                }
                return tmpArr.count
            }
            return 0
        }
    }
    
    var isNeedInfinite: Bool = false
    
    var timer: String?
    
    
    init(frame: CGRect = CGRect.zero,direction: UICollectionView.ScrollDirection? = UICollectionView.ScrollDirection.horizontal, placeHolderImage: UIImage?, contentModel: UIView.ContentMode? = UIView.ContentMode.scaleToFill, isInfinite: Bool? = false, sourceArr: [String], infiniteTime: TimeInterval = 2.0) {
        super.init(frame: frame)
        placeHolderImg = placeHolderImage
        cellContentMode = contentModel!
        scrollDirection = direction!
        isNeedInfinite = isInfinite!
        sourceImgArr = sourceArr
        tInfiniteTime = infiniteTime
        setupCollection()
        createTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = self.bounds.size
        collectionView?.frame = self.bounds
        scrollToMiddleSection(animate: false)
    }
}

extension MMInfiniteCycleView {
    func setupCollection() -> Void {
        let flowlayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowlayout.minimumLineSpacing = 0
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.scrollDirection = scrollDirection
        
        let _collectionView = UICollectionView(frame: bounds, collectionViewLayout: flowlayout)
        _collectionView.register(MMInfiniteCVCell.self, forCellWithReuseIdentifier: MMInfiniteCVCell.InfiniteCellID)
        _collectionView.delegate = self
        _collectionView.dataSource = self
        _collectionView.isPagingEnabled = true
        _collectionView.bounces = false
//        _collectionView.showsHorizontalScrollIndicator = false
        _collectionView.showsVerticalScrollIndicator = false
        if #available(iOS 11.0, *) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            
        }
        collectionView = _collectionView
        addSubview(collectionView!)
    }
    
    func createTimer() -> Void {
        guard isNeedInfinite else {
            return
        }
        cancelTimer()
        timer = MMDispatchTimer.createTimer(startTime: 2.0, infiniteInterval: tInfiniteTime, isRepeat: isNeedInfinite, async: false, target: self, selector: #selector(scrollToNextPage))
    }
    
    func cancelTimer() -> Void {
        guard isNeedInfinite else {
            return
        }
        if let tTimer = timer,tTimer.count > 0 {
            MMDispatchTimer.cancelTimer(timerName: tTimer)
        }
    }
    
    @objc func scrollToNextPage() -> Void {
        MMLog(message: "scrollToNextPage")
        if let cells: [UICollectionViewCell] = collectionView?.visibleCells, cells.count > 0 {
            MMLog(message: cells)
            guard let indexPath = collectionView?.indexPath(for: cells.first!) else { return }
            var nextIndex: IndexPath?
            if indexPath.section + 1 == itemSectionCount && indexPath.row + 1 == sourceImgArr?.count {
//                let section = floor((Double(itemSectionCount) / 2.0)) - 1
//                let indexPath = IndexPath(row: indexPath.row, section: Int(section))
//                collectionView!.scrollToItem(at: indexPath, at: .init(rawValue: 0), animated: false)
                scrollToMiddleSection()
                return
            } else if indexPath.row + 1 == sourceImgArr?.count {
                nextIndex = IndexPath(row: 0, section: indexPath.section + 1)
            } else {
                nextIndex = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            }
            collectionView?.scrollToItem(at: nextIndex!, at: .init(rawValue: 0), animated: true)
        }
    }
    
    func scrollToMiddleSection(animate: Bool = true) -> Void {
        if let sourceArr = sourceImgArr, sourceArr.count > 1 {
            let section = floor((Double(itemSectionCount) / 2.0))
            let indexPath = IndexPath(row: 0, section: Int(section))
            collectionView!.scrollToItem(at: indexPath, at: .init(rawValue: 0), animated: animate)
        }
    }
}
extension MMInfiniteCycleView: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let sourceArr = sourceImgArr, sourceArr.count > 1 {
            return itemSectionCount
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sourceArr = sourceImgArr {
            return sourceArr.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MMInfiniteCVCell.InfiniteCellID, for: indexPath) as! MMInfiniteCVCell
        cell.singleImageView?.contentMode = cellContentMode
        let url = URL(string: sourceImgArr![indexPath.row])
        cell.singleImageView?.kf.setImage(with: url, placeholder: placeHolderImg)
        
        return cell
    }
}

extension MMInfiniteCycleView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        MMLog(message: "scrollViewWillBeginDragging")
        cancelTimer()
    }
    
    /// 停止拖拽
    ///
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        MMLog(message: "scrollViewDidEndDragging----\(decelerate)")
        createTimer()
    }
    
    /// 停止
    ///
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        MMLog(message: "scrollViewDidEndDecelerating")
        if isNeedInfinite,let cells: [UICollectionViewCell] = collectionView?.visibleCells, cells.count > 0 {
            MMLog(message: cells)
            guard let indexPath = collectionView?.indexPath(for: cells.first!) else { return }
            if indexPath.section + 1 == itemSectionCount && indexPath.row + 1 == sourceImgArr?.count {
                let section = floor((Double(itemSectionCount) / 2.0)) - 1
                let tIndexPath = IndexPath(row: indexPath.row, section: Int(section))
                collectionView!.scrollToItem(at: tIndexPath, at: .init(rawValue: 0), animated: false)
            } else if indexPath.section == 0 && indexPath.row == 0 {
                scrollToMiddleSection(animate: false)
            }
        }
    }
    
    /// 手指离开开始减速 但是要当  scrollViewDidEndDragging 中的 decelerate 为 true 时才会调用
    ///
    /// - Parameter scrollView: <#scrollView description#>
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        MMLog(message: "scrollViewDidEndScrollingAnimation")
    }
    
    
}
