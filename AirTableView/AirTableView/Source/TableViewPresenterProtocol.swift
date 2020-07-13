//
//  TableViewPresenterProtocol.swift
//  AppSpace
//
//  Created by Lysytsia Yurii on 03.07.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import UIKit

// MARK: - TableViewPresenterProtocol
protocol TableViewPresenterProtocol: class {
    
    var tableSections: Int { get }
    
    func tableRows(for section: Int) -> Int
    
    func tableRowIdentifier(for indexPath: IndexPath) -> String
    func tableRowHeight(for indexPath: IndexPath) -> UITableView.RowHeight
    func tableRowModel(for indexPath: IndexPath) -> Any?
    
    func tableRowDidSelect(at indexPath: IndexPath)
    func tableRowDidDeselect(at indexPath: IndexPath)
    
    func tableLeadingSwipeActionsConfiguration(for indexPath: IndexPath) -> UISwipeActionsConfiguration?
    func tableTrailingSwipeActionsConfiguration(for indexPath: IndexPath) -> UISwipeActionsConfiguration?
    
    func tableHeaderIdentifier(for section: Int) -> String?
    func tableHeaderHeight(for section: Int) -> UITableView.RowHeight
    func tableHeaderModel(for section: Int) -> Any?
    
    func tableFooterIdentifier(for section: Int) -> String?
    func tableFooterHeight(for section: Int) -> UITableView.RowHeight
    func tableFooterModel(for section: Int) -> Any?
    
    func tableSectionIndexTitles(for tableView: UITableView) -> [String]?
    
}

extension TableViewPresenterProtocol {
    
    var tableSections: Int {
        return 1
    }
    
    func tableRowDidSelect(at indexPath: IndexPath) {
        
    }
    
    func tableRowDidDeselect(at indexPath: IndexPath) {
        
    }
    
    func tableLeadingSwipeActionsConfiguration(for indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    func tableTrailingSwipeActionsConfiguration(for indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    func tableHeaderIdentifier(for section: Int) -> String? {
        return nil
    }
    
    func tableHeaderHeight(for section: Int) -> UITableView.RowHeight {
        return .flexible
    }
    
    func tableHeaderModel(for section: Int) -> Any? {
        return nil
    }
    
    func tableFooterIdentifier(for section: Int) -> String? {
        return nil
    }
    
    func tableFooterHeight(for section: Int) -> UITableView.RowHeight {
        return .flexible
    }
    
    func tableFooterModel(for section: Int) -> Any? {
        return nil
    }
    
    func tableSectionIndexTitles(for tableView: UITableView) -> [String]? {
        return nil
    }
    
}
