//
//  NumbersViewOutput.swift
//  NumbersDemo
//
//  Created by Azat Almeev on 07/07/2019.
//  Copyright © 2019 Azat Almeev. All rights reserved.
//

import Services

protocol NumbersViewOutput {

    var sections: [NumbersPresenter.Section] { get }
    
    func viewIsReady()
    func handleReloadData()
}
