//
//  UIView+Ext.swift
//  UIView extensions for commonly used helper function

import UIKit

extension UIView {
    
    /// Ability to add multiple subviews to a parent view at a time
    /// - Parameter views: the view or views to be added
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
    
    /// Helper function to tell iOS to not create Auto Layout constraints automatically
    /// - Parameter views: the view or views to remove automatic constraints
    func useConstraints(_ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
