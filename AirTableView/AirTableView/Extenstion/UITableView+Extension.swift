//
//  UITableView+Extension.swift
//  AirTableView
//
//  Created by Lysytsia Yurii on 14.07.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import class UIKit.UITableView
import class UIKit.UITableViewCell
import class UIKit.UITableViewHeaderFooterView

extension UITableView {
    
    func register<T: UITableViewCell>(_ cellClass: T.Type) where T: NibLoadableView {
        self.register(cellClass.nib(), forCellReuseIdentifier: cellClass.viewIdentifier)
    }
    
    func register<T: UITableViewHeaderFooterView>(_ viewClass: T.Type) where T: NibLoadableView {
        self.register(T.nib(), forHeaderFooterViewReuseIdentifier: T.viewIdentifier)
    }
    
}
