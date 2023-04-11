//
//  UITableView+Ext.swift
//  UITableView extensions for readability and helper functions

import UIKit

extension UITableView {
    
    /// Reloads the table view on the main thread
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
    
    /// Removes excess cells that are left from the bottom of the table view
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
