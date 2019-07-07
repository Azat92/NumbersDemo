//
//  NumbersPresenter.swift
//  NumbersDemo
//
//  Created by Azat Almeev on 07/07/2019.
//  Copyright © 2019 Azat Almeev. All rights reserved.
//

import Services

final class NumbersPresenter {
    
    struct Section {
        
        fileprivate let index: Int
        let title: String
        let items: [ListItem]
    }

    var numbersService: NumbersService!
    weak var view: NumbersViewInput?
    private (set) var sections: [Section] = []
    
    private var cancellationToken: Cancellable? {
        didSet {
            oldValue?()
        }
    }
    
    deinit {
        cancellationToken?()
    }
}

// MARK: - Numbers View Output
extension NumbersPresenter: NumbersViewOutput {
    
    func viewIsReady() {
        handleReloadData()
    }
    
    func handleReloadData() {
        view?.showLoading()
        cancellationToken = numbersService.numbers { result in
            switch result {
            case .success(let numbers):
                let dictionary = Dictionary(grouping: numbers) { $0.section }
                let sections = dictionary.compactMap { key, value -> Section? in
                    guard let first = value.first else { return nil }
                    return Section(index: key, title: first.sectionTitle, items: value.sorted { $0.value < $1.value })
                }
                self.sections = sections.sorted { $0.index < $1.index }
                self.view?.showData()
            case .failure(let error):
                self.view?.show(error: error)
            }
        }
    }
}
