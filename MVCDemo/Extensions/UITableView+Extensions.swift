//
//  UITableView+Extensions.swift
//  MVCDemo
//
//  Created by Mikis Woodwinter on 4/6/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

import UIKit

extension UITableView {
    func registerReusableCell<T: UITableViewCell>(_: T.Type) where T: Reusable {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: Reusable {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
