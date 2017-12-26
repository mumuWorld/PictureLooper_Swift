//
//  FirstViewController.swift
//  Demo汇总
//
//  Created by YangJie on 2017/12/22.
//  Copyright © 2017年 YangJie. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController ,PictureLoopDelegate{

    var pictureLoop: PictureLoopView?
    private lazy var pictureArray:[String] = {
        var arr:[String] = Array()
        for i in 0..<5 {
            arr.append(String.init(format: "%i", i))
        }
        return arr
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRect.init(x: 0, y: 64, width: UIScreen.main.bounds.width, height: 200)
        
        pictureLoop = PictureLoopView.init(pictureArray: pictureArray, frame: frame)
        pictureLoop?.delegate = self
        view.addSubview(pictureLoop!)
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
//         MMLog(message: NSStringFromCGRect(view.frame))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension FirstViewController {
    func pictureLoopImageClick(pictureView: PictureLoopView, withTag btnTag: Int) {
        MMLog(message: PictureLoopView.description())
        MMLog(message: "当前第 \(btnTag) 张图片")
    }
}
