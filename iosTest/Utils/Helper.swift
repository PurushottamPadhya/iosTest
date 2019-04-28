//
//  Helper.swift
//  iosTest
//
//  Created by Purushottam on 4/27/19.
//  Copyright © 2019 Purushottam. All rights reserved.
//
import UIKit
import Foundation

class Helper: NSObject {
    class func showToastOnView(message : String, view: UIView?) {

        var heightOfLabel: CGFloat = 50.0
        if  let customfont = UIFont(name: "HelveticaNeue-Thin", size: 14) {
            let height = self.heightForView(text: message, font: customfont, width: view?.frame.size.width ?? UIScreen.main.bounds.width)
            if height > heightOfLabel{
                heightOfLabel = height
            }
            
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.toastLabel.removeFromSuperview()
        appDelegate.toastLabel.backgroundColor = UIColor.primaryAppColor
        appDelegate.toastLabel.textColor = UIColor.white
        appDelegate.toastLabel.numberOfLines = 0
        appDelegate.toastLabel.lineBreakMode = .byWordWrapping
        appDelegate.toastLabel.textAlignment = .center;
        appDelegate.toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        appDelegate.toastLabel.text = message
        appDelegate.toastLabel.alpha = 1.0
        appDelegate.toastLabel.clipsToBounds  =  true
        appDelegate.window?.addSubview(appDelegate.toastLabel)
        
        
        appDelegate.toastLabel.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            
            if let guide = appDelegate.window?.safeAreaLayoutGuide{
                appDelegate.toastLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
                appDelegate.toastLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
                appDelegate.toastLabel.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
                
                appDelegate.toastLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
            }
            
        } else {
            
            NSLayoutConstraint(item: appDelegate.toastLabel, attribute: .leading, relatedBy: .equal, toItem: appDelegate.window, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: appDelegate.toastLabel, attribute: .trailing, relatedBy: .equal, toItem: appDelegate.window, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: appDelegate.toastLabel, attribute: .bottom, relatedBy: .equal, toItem: appDelegate.window, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
            appDelegate.toastLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            appDelegate.toastLabel.removeFromSuperview()
        }
        
        
    }
    
    class func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
}



