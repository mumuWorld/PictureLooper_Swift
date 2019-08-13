//
//  DispatchTime+ Extension.swift
//  MMQRCode
//
//  Created by yangjie on 2019/8/5.
//  Copyright © 2019 yangjie. All rights reserved.
//

import Foundation

extension DispatchTime {
    
   /// 提供Int
   ///
   /// - Parameter value: Int 默认0
   /// - Returns: DispatchTime
    static func secondTime(value: Int = 0) -> DispatchTime {
        let time = DispatchTime.now() + .seconds(value)
        return time
    }
    /// 提供Double
    ///
    /// - Parameter value: Double 默认0
    /// - Returns: DispatchTime
    static func secondTime(value: Double = 0.0) -> DispatchTime {
        let time = DispatchTime.now() + .milliseconds(Int(value * 1000))
        return time
    }
}
