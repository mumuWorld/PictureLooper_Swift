//
//  PictureLoopView.swift
//  Demo汇总
//
//  Created by YangJie on 2017/12/22.
//  Copyright © 2017年 YangJie. All rights reserved.
//

import UIKit

protocol PictureLoopDelegate {
    func pictureLoopImageClick(pictureView: PictureLoopView ,withTag btnTag: Int)
}

class PictureLoopView: UIView,UIScrollViewDelegate {

    
    private lazy var scrollView = UIScrollView()
    private lazy var pageControl = UIPageControl()
    private var width:CGFloat!
    private var height:CGFloat!
    let btnCount:Int = 3
    public var isNeedPortrait:Bool! = false;
    
    public var mPictureArray:[String]!
    
    public var delegate:PictureLoopDelegate?
    
    private var timer:Timer?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        
        for _ in 0..<btnCount {
            scrollView.addSubview(UIButton())
        }
        
        addSubview(pageControl)
    }
    convenience init(pictureArray:Array<String>,frame: CGRect,isPortrait: Bool=false) {
        self.init(frame: frame)
//        self.backgroundColor = UIColor.blue
        mPictureArray = pictureArray
        width = frame.size.width
        height = frame.size.height
        isNeedPortrait = isPortrait
        MMLog(message: NSStringFromCGRect(frame))
        pageControl.numberOfPages = mPictureArray!.count
        self.pageControl.currentPage = 0
        //设置显示内容
        setContent()
        //开启定时器
        startTimer()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        MMLog(message: "layoutSubviews")
        scrollView.frame = bounds
        if  isNeedPortrait {
            scrollView.contentSize = CGSize.init(width: width, height: height*CGFloat(btnCount))
        } else {
            scrollView.contentSize = CGSize.init(width: width*CGFloat(btnCount), height: height)
        }
//        添加三张图片按钮
        for i in 0..<btnCount {
            let btn = scrollView.subviews[i] as! UIButton
            btn.addTarget(self, action: #selector(imgBtnClick(btn:)), for: .touchUpInside)
            if isNeedPortrait! {
                btn.frame = CGRect.init(x: 0, y: height*CGFloat(i), width: width, height: height)
            } else {
                btn.frame = CGRect.init(x: width*CGFloat(i), y: 0, width: width, height: height)
            }
        }
        if isNeedPortrait {
            scrollView.contentOffset = CGPoint.init(x: 0, y: height)//显示中间的图片
        } else {
            scrollView.contentOffset = CGPoint.init(x: width, y: 0)
        }
        let pcW:CGFloat = 100
        let pcH:CGFloat = 20
        pageControl.frame = CGRect.init(x: width-pcW, y: height-pcH, width: pcW, height: pcH)
   
       
    }
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
}
//MARK:  设置UI方法
extension PictureLoopView {
    func setContent() -> Void {
        for i in 0..<btnCount {
            let btn = scrollView.subviews[i] as! UIButton
            var index = pageControl.currentPage
            if(i == 0){
                index-=1
            } else if(i == 2){
                index+=1
            }
            //无限循环处理
            if(index < 0){
                index = pageControl.numberOfPages-1
            } else if(index == pageControl.numberOfPages){
                index = 0
            }
            btn.tag = index
            btn.setImage(UIImage.init(named: mPictureArray[index]), for: .normal)
            btn.setImage(UIImage.init(named: mPictureArray[index]), for: .highlighted)
        }
    }
    func startTimer() -> Void {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(nextImage(timer:)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    func endTimer() -> Void {
        timer?.invalidate()
        timer = nil
    }
    @objc private func nextImage(timer:Timer) -> Void {
        if isNeedPortrait {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 2*height), animated: true)
        } else {
            scrollView.setContentOffset(CGPoint.init(x: 2*width, y: 0), animated: true)
        }
    }
    func updateContent() -> Void {
        setContent()
        if  isNeedPortrait {
            scrollView.contentOffset = CGPoint.init(x: 0, y: height)//显示中间的图片
        } else {
            scrollView.contentOffset = CGPoint.init(x: width, y: 0)
        }
    }
}
//MARK:  代理方法
extension PictureLoopView {
    @objc private func imgBtnClick(btn: UIButton){
        delegate?.pictureLoopImageClick(pictureView: self, withTag: btn.tag)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var index = 0
//        用于提取最小便宜距离
        var minDistance:CGFloat = CGFloat(MAXFLOAT)
        for i in 0..<btnCount {
            let btn = scrollView.subviews[i] as! UIButton
            var distance:CGFloat = 0
            
            if isNeedPortrait {
                distance = abs(btn.frame.origin.y-scrollView.contentOffset.y)
            } else {
                distance = abs(btn.frame.origin.x-scrollView.contentOffset.x)
            }
            if distance < minDistance {
                minDistance = distance
                index = btn.tag
            }
        }
        pageControl.currentPage = index
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       endTimer()
    }
//    结束拖拽
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
//    减速滚动
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateContent()
    }
//    动画结束
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateContent()
    }
}
