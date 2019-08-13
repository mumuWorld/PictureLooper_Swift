//
//  FirstViewController.swift
//  Demo汇总
//
//  Created by YangJie on 2017/12/22.
//  Copyright © 2017年 YangJie. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    var pictureLoop: MMInfiniteCycleView?
    
    private lazy var pictureArray:[String] = {
        var arr:[String] = Array()
        arr.append("https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2709494055,3727918964&fm=26&gp=0.jpg")
        arr.append("https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1120375073,4039537831&fm=26&gp=0.jpg")
        arr.append("https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=933865351,281155046&fm=26&gp=0.jpg")
        arr.append("https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=225806716,638269697&fm=26&gp=0.jpg")

        
//        for i in 0..<5 {
//            arr.append(String.init(format: "%i", i))
//        }
        return arr
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let tFrame = CGRect.init(x: 0, y: 64, width: UIScreen.main.bounds.width, height: 200)
        pictureLoop = MMInfiniteCycleView(frame: tFrame, placeHolderImage: nil, isInfinite: true, sourceArr: pictureArray)
//        pictureLoop = PictureLoopView.init(pictureArray: pictureArray, frame: frame)
//        pictureLoop?.delegate = self
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

}
