//
//  ViewHeight.swift
//  AirTableView
//
//  Created by Lysytsia Yurii on 13.07.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import struct CoreGraphics.CGFloat
import class UIKit.UITableView

extension UITableView {

    /// Model for set table view header or footer height
    public enum ViewHeight {
        /// Table view header or footer heaight will be `0`. So table view header or footer won't be visible
        case none
        
        /// Dynamic table view header or footer height. Height will be calculated automatically and save to cache
        case flexible
        
        /// Fixed table view header or footer height
        case fixed(CGFloat)
    }
    
}
