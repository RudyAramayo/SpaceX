//
//  Utilities.swift
//  SpaceX
//
//  Created by Rudy Aramayo on 12/18/18.
//  Copyright © 2018 OrbitusRobotics. All rights reserved.
//

import UIKit

extension Date {
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}

//This forces the call to be made on our view controller which propagates into our method to request a status bar change
extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}


extension UIColor {    
    
    var statusBarGrayColor: UIColor {
        //choose your custom rgb values
        return UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.75)
    }
    
    var navigationBarWhiteColor: UIColor {
        //choose your custom rgb values
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.85)
    }
    
    var statusBarBlueStandardButtonTint: UIColor {
        //choose your custom rgb values
        return UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
    }
    
    var statusBarDarkColor: UIColor {
        //choose your custom rgb values
        return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    }
    
    
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
