//
//  RowHeight.swift
//  AirTableView
//
//  Created by Lysytsia Yurii on 13.07.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import struct CoreGraphics.CGFloat
import class UIKit.UITableView

extension UITableView {

    /// Model for set table view row height
    public enum RowHeight {
        
        /// Dynamic table view row height. Height will be calculated automatically and save to cache
        case flexible
        
        /// Fixed table view row height
        case fixed(CGFloat)
    }
    
}
