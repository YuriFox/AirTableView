//
//  TableViewControllerProtocol.swift
//  AppSpace
//
//  Created by Lysytsia Yurii on 03.07.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import UIKit

// MARK: - TableViewControllerProtocol
protocol TableViewControllerProtocol: class {
    
    var tableViewSource: UITableView { get }
    var tableViewPresenter: TableViewPresenterProtocol { get }
 
    func configureTableView(configurator: (UITableView) -> Void)
    
    func reloadTableView()
    
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    
    func indexPathForRow(with view: UIView) -> IndexPath?
    
    func selectRow(at indexPath: IndexPath, animated: Bool, scrollPosition: UITableView.ScrollPosition)
    
}

fileprivate var tableViewDataKey: String = "TableViewControllerProtocol.tableViewData"

extension TableViewControllerProtocol {
    
    var tableViewData: TableViewData {
        if let data = objc_getAssociatedObject(self, &tableViewDataKey) as? TableViewData {
            return data
        } else {
            // Create new `tableViewData` model
            let tableViewData = TableViewData(input: self, output: self.tableViewPresenter)
            objc_setAssociatedObject(self, &tableViewDataKey, tableViewData, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return tableViewData
        }
    }
    
    public func configureTableView(configurator: (UITableView) -> Void) {
        self.tableViewSource.dataSource = self.tableViewData
        self.tableViewSource.delegate = self.tableViewData
        configurator(self.tableViewSource)
    }
    
    public func reloadTableView() {
        self.tableViewData.reloadAll()
        self.tableViewSource.reloadData()
    }
    
    public func reconfigureCellForRow(at indexPath: IndexPath) {
        guard let cell = self.tableViewSource.cellForRow(at: indexPath) else {
            return
        }
        self.tableViewData.configureCell(cell, for: indexPath)
    }
    
    public func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        self.tableViewSource.beginUpdates()
        self.tableViewData.reloadRows(at: indexPaths)
        self.tableViewSource.reloadRows(at: indexPaths, with: animation)
        self.tableViewSource.endUpdates()
    }
    
    func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        self.tableViewSource.beginUpdates()
        self.tableViewData.reloadRows(at: indexPaths)
        self.tableViewSource.deleteRows(at: indexPaths, with: animation)
        self.tableViewSource.endUpdates()
    }
    
    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        self.tableViewSource.beginUpdates()
        self.tableViewData.reloadRows(at: indexPaths)
        self.tableViewSource.insertRows(at: indexPaths, with: animation)
        self.tableViewSource.endUpdates()
    }
    
    func reloadTableViewSection(_ section: Int, animation: UITableView.RowAnimation) {
        self.reloadTableViewSections([section], animation: animation)
    }
    
    func reloadTableViewSections(_ sections: [Int], animation: UITableView.RowAnimation) {
        sections.forEach { self.tableViewData.reloadSection($0) }
        let indexSet = IndexSet(sections)
        self.tableViewSource.performBatchUpdates({
            self.tableViewSource.reloadSections(indexSet, with: animation)
        }, completion: nil)
    }
    
    func indexPathForRow(with view: UIView) -> IndexPath? {
        let point = view.convert(CGPoint.zero, to: self.tableViewSource)
        return self.tableViewSource.indexPathForRow(at: point)
    }
    
    func selectRow(at indexPath: IndexPath, animated: Bool, scrollPosition: UITableView.ScrollPosition)  {
        self.tableViewSource.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
    }
    
}
