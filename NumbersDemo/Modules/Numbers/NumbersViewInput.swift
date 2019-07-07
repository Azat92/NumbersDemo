//
//  NumbersViewInput.swift
//  NumbersDemo
//
//  Created by Azat Almeev on 07/07/2019.
//  Copyright © 2019 Azat Almeev. All rights reserved.
//

import UIKit

protocol NumbersViewInput: AnyObject {

    func showLoading()
    func show(error: Error)
    func showData()
}
