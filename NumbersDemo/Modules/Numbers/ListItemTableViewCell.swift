//
//  ListItemTableViewCell.swift
//  NumbersDemo
//
//  Created by Azat Almeev on 07/07/2019.
//  Copyright © 2019 Azat Almeev. All rights reserved.
//

import UIKit
import Services

final class ListItemTableViewCell: UITableViewCell {

    func configure(with item: ListItem) {
        textLabel?.text = item.displayValue
        accessoryType = item.isSelected ? .checkmark : .none
    }
}
