//
//  UITableView+UIComponents.swift
//  UIComponents
//
//  Created by Azat Almeev on 07/07/2019.
//  Copyright © 2019 Azat Almeev. All rights reserved.
//

import UIKit

private extension UITableViewCell {
    
    class var selfName: String {
        let identifier = Bundle(for: self).bundleIdentifier?.components(separatedBy: ".").last ?? "NumbersDemo"
        return NSStringFromClass(self).replacingOccurrences(of: "\(identifier).", with: "")
    }
    
    class var cellIdentifier: String {
        return "\(selfName)Identifier"
    }
}

public extension UITableView {
    
    /// Registers given UITableViewCell subclass to table view reusable pool
    ///
    /// - Parameter type: type of cell to register
    func register<T: UITableViewCell>(with type: T.Type) {
        register(T.self, forCellReuseIdentifier: T.cellIdentifier)
    }
    
    /// Dequeues given UITableViewCell subclass from reusable pool. Will crash if cell if not registered
    ///
    /// - Parameter type: type of cell to dequeue
    /// - Returns: cell ready to use
    func dequeue<T: UITableViewCell>(with type: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: type.cellIdentifier) as! T
    }
}
