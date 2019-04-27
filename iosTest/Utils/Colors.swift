//
//  Colors.swift
//  iosTest
//
//  Created by Purushottam on 4/27/19.
//  Copyright © 2019 Purushottam. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    // theme colors
    static let primaryAppColor = UIColor(rgb: 0xDA2D29) // red for background view
    static let secondaryAppColor = UIColor(rgb: 0xA92A41) // dark red for buttons
    static let ultraLightAppColor = UIColor(rgb: 0xF6F6F6) // gray color
    static let clearAppColor = UIColor(rgb: 0xFFFFFF) // white color
    
    
    // theme colors texts
    static let titleTextColor = UIColor.black // white color
    static let subtitleTextColor = UIColor(rgb: 0xFFFFFF).withAlphaComponent(0.5) // white color
    static let subtitleLightTextColor = UIColor(rgb: 0xF6F6F6) // gray color
    static let clearTextColor = UIColor(rgb: 0xFFFFFF) // white color
    
    
    static let primaryTextColor = UIColor(rgb: 0xDA2D29) // red for background view
    static let secondaryTextColor = UIColor(rgb: 0xA92A41) // dark red for buttons


}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
}

