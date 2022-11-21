//
//  UIView+Ext.swift
//  Recipesto
//
//  Created by Max Park on 11/20/22.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}
