//
//  TableViewData.swift
//  AppSpace
//
//  Created by Lysytsia Yurii on 03.07.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize
import class UIKit.UITableView
import class UIKit.UITableViewCell
import class UIKit.UITableViewHeaderFooterView
import class UIKit.UISwipeActionsConfiguration
import class UIKit.UIView
import protocol UIKit.UITableViewDataSource
import protocol UIKit.UITableViewDelegate

/// Data for building `UITableView` based on `UITableViewDataSource` and `UITableViewDelegate`
class TableViewData: NSObject {

    // MARK: Stored properties
    
    /// Array of sections (array of rows) with estimated sizes for table view row. First array is equal to `IndexPath.section`, second to `IndexPath.row`
    private var estimatedHeightsForRow = [[CGFloat]]()
    
    /// Array of sections with estimated sizes for table view header. Element of array is equal to `IndexPath.section`
    private var estimatedHeightsForHeader = [CGFloat]()
    
    /// Array of sections with estimated sizes for table view footer. Element of array is equal to `IndexPath.section`
    private var estimatedHeightsForFooter = [CGFloat]()
    
    // MARK: Dependency injection
    private unowned var input: TableViewControllerProtocol
    private unowned var output: TableViewPresenterProtocol
    
    // MARK: Initialize
    init(input: TableViewControllerProtocol, output: TableViewPresenterProtocol) {
        self.input = input
        self.output = output
    }
    
    // MARK: Functions
    
    /// Reload all (remove cache) table view data
    func reloadAll() {
        self.estimatedHeightsForRow.removeAll()
        self.estimatedHeightsForHeader.removeAll()
        self.estimatedHeightsForFooter.removeAll()
    }
    
    /// Reload (remove cache) for specific section of table view data
    func reloadSection(_ section: Int) {
        if self.estimatedHeightsForRow.indices.contains(section) {
            self.estimatedHeightsForRow[section].removeAll()
        }
        if self.estimatedHeightsForHeader.indices.contains(section) {
            self.estimatedHeightsForHeader[section] = UITableView.automaticDimension
        }
        if self.estimatedHeightsForFooter.indices.contains(section) {
            self.estimatedHeightsForFooter[section] = UITableView.automaticDimension
        }
    }
    
    /// Reload (remove cache) for specific sections of table view data. It's the same as `reloadSection(_:)` but for multiple sections
    func reloadSections(_ sections: [Int]) {
        sections.forEach { self.reloadSection($0) }
    }
    
    /// Reload (remove cache) for specific index path of table view data
    func reloadRow(at indexPath: IndexPath) {
        guard self.estimatedHeightsForRow.indices.contains(indexPath.section) else {
            return
        }
        guard self.estimatedHeightsForRow[indexPath.section].indices.contains(indexPath.row) else {
            return
        }
        self.estimatedHeightsForRow[indexPath.section][indexPath.row] = UITableView.automaticDimension
    }
    
    /// Reload (remove cache) for specific index paths of table view data. It's the same as `reloadRow(at:)` but for multiple index paths
    func reloadRows(at indexPaths: [IndexPath]) {
        indexPaths.forEach { self.reloadRow(at: $0) }
    }
    
    // MARK: Configure
    
    /// Configure table view cell with some model. Cell must implement `ConfigurableView` protocol.
    func configureCell(_ cell: UITableViewCell, for indexPath: IndexPath) {
        guard let configurableCell = cell as? ConfigurableView else {
            assertionFailure("For use `TableViewData.configureCell(_:for:)`and configure cell you must implement `ConfigurableView` protocol for cell type `\(type(of: cell))`")
            return
        }
        guard let model = self.output.tableRowModel(for: indexPath) else {
            return
        }
        configurableCell.configure(model: model)
    }
    
    /// Configure table header view with some model. Header view must implement `ConfigurableView` protocol.
    func configureHeaderView(_ view: UITableViewHeaderFooterView, for section: Int) {
        guard let configurableView = view as? ConfigurableView else {
            assertionFailure("For use `TableViewData.configureHeaderView(_:for:)`and configure header view you must implement `ConfigurableView` protocol for header view type `\(type(of: view))`")
            return
        }
        guard let model = self.output.tableHeaderModel(for: section) else {
            return
        }
        configurableView.configure(model: model)
    }
    
    /// Configure table footer view with some model. Footer view must implement `ConfigurableView` protocol.
    func configureFooterView(_ view: UITableViewHeaderFooterView, for section: Int) {
        guard let configurableView = view as? ConfigurableView else {
            assertionFailure("For use `TableViewData.configureFooterView(_:for:)`and configure footer view you must implement `ConfigurableView` protocol for footer view type `\(type(of: view))`")
            return
        }
        guard let model = self.output.tableFooterModel(for: section) else {
            return
        }
        configurableView.configure(model: model)
    }
    
}

// MARK: UITableViewDataSource
extension TableViewData: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.output.tableSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.output.tableRows(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewIdentifier = self.output.tableRowIdentifier(for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: viewIdentifier, for: indexPath)
        self.configureCell(cell, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let hasLeadingActions = self.tableView(tableView, leadingSwipeActionsConfigurationForRowAt: indexPath) != nil
        let hasTrailingActions = self.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: indexPath) != nil
        return hasLeadingActions || hasTrailingActions
    }
 
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.output.tableSectionIndexTitles(for: tableView)
    }
    
}

// MARK: UITableViewDelegate
extension TableViewData: UITableViewDelegate {
    
    // MARK: Cell
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = self.estimatedHeightsForRow[safe: indexPath.section]?[safe: indexPath.row] {
            return height
        }
        
        switch self.output.tableRowHeight(for: indexPath) {
        case .fixed(let height):
            self.estimatedHeightsForRow[indexPath.section][indexPath.row] = height
            return height
            
        case .flexible:
            let cell = self.tableView(tableView, cellForRowAt: indexPath)
            cell.layoutIfNeeded()
            let targetSize = CGSize(width: tableView.frame.width, height: CGFloat.greatestFiniteMagnitude)
            let prefferedSize = cell.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            let height = prefferedSize.height
            self.estimatedHeightsForRow[indexPath.section][indexPath.row] = height
            return height
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard self.estimatedHeightsForRow.indices.contains(indexPath.section) else {
            assertionFailure("Something went wrong")
            return UITableView.automaticDimension
        }
        guard self.estimatedHeightsForRow[indexPath.section].indices.contains(indexPath.row) else {
            assertionFailure("Something went wrong")
            return UITableView.automaticDimension
        }
        return self.estimatedHeightsForRow[indexPath.section][indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.output.tableRowDidSelect(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.output.tableRowDidDeselect(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return self.output.tableLeadingSwipeActionsConfiguration(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return self.output.tableTrailingSwipeActionsConfiguration(for: indexPath)
    }
    
    // MARK: Header
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if let height = self.estimatedHeightsForHeader[safe: section] {
            return height
        }
        
        switch self.output.tableHeaderHeight(for: section) {
        case .none:
            return 0
            
        case .fixed(let height):
            self.estimatedHeightsForHeader[section] = height
            return height
            
        case .flexible:
            guard let view = self.tableView(tableView, viewForHeaderInSection: section) else {
                assertionFailure("View for header in section `\(section)` is nil")
                return UITableView.automaticDimension
            }
            view.layoutIfNeeded()
            let targetSize = CGSize(width: tableView.frame.width, height: CGFloat.greatestFiniteMagnitude)
            let prefferedSize = view.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            let height = prefferedSize.height
            self.estimatedHeightsForHeader[section] = height
            return height
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let height = self.estimatedHeightsForHeader[safe: section] {
            return height
        } else {
            return self.tableView(tableView, estimatedHeightForHeaderInSection: section)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let identifier = self.output.tableHeaderIdentifier(for: section) else {
            return nil
        }
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) else {
            assertionFailure("Table view data can't dequeue reusable header view with identifier `\(identifier)`. Maybe table view not register header with identifier `\(identifier)`")
            return nil
        }
        self.configureHeaderView(view, for: section)
        return view
    }
    
    // MARK: Footer
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        if let height = self.estimatedHeightsForFooter[safe: section] {
            return height
        }
        
        switch self.output.tableFooterHeight(for: section) {
        case .none:
            return 0
            
        case .fixed(let height):
            self.estimatedHeightsForFooter[section] = height
            return height
            
        case .flexible:
            guard let view = self.tableView(tableView, viewForFooterInSection: section) else {
                assertionFailure("View for footer in section `\(section)` is nil")
                return UITableView.automaticDimension
            }
            view.layoutIfNeeded()
            let targetSize = CGSize(width: tableView.frame.width, height: CGFloat.greatestFiniteMagnitude)
            let prefferedSize = view.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            let height = prefferedSize.height
            self.estimatedHeightsForFooter[section] = height
            return height
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let height = self.estimatedHeightsForFooter[safe: section] {
            return height
        } else {
            return self.tableView(tableView, estimatedHeightForFooterInSection: section)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let identifier = self.output.tableFooterIdentifier(for: section) else {
            return nil
        }
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) else {
            assertionFailure("Table view data can't dequeue reusable footer view with identifier `\(identifier)`. Maybe table view not register footer with identifier `\(identifier)`")
            return nil
        }
        self.configureFooterView(view, for: section)
        return view
    }

}
