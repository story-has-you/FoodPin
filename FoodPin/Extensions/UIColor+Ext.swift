//
//  UIColor+Ext.swift
//  FoodPin
// 自定义颜色扩展
//  Created by 方曦 on 2023/7/29.
//

import UIKit

extension UIColor {
    
    /**
     便利型初始器
     */
    convenience init(red: Int, green: Int, blue: Int) {
        let redValue = CGFloat(red) / 255.0
        let greenValue = CGFloat(green) / 255.0
        let blueValue = CGFloat(blue) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
    }
}
