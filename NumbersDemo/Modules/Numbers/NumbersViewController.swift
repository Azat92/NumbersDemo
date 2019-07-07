//
//  NumbersViewController.swift
//  NumbersDemo
//
//  Created by Azat Almeev on 07/07/2019.
//  Copyright © 2019 Azat Almeev. All rights reserved.
//

import UIKit
import UIComponents
 
final class NumbersViewController: UITableViewController {
    
    var output: NumbersViewOutput!
    
    private let loadingIndicator: UIActivityIndicatorView = {
        return UIActivityIndicatorView(style: .gray)
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = PaddingLabel(frame: view.bounds)
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshControlDidFire(_:)), for: .valueChanged)
        tableView.register(with: ListItemTableViewCell.self)
        output.viewIsReady()
    }
    
    @IBAction func refreshControlDidFire(_ sender: UIRefreshControl) {
        output.handleReloadData()
    }
}

// MARK: - Table View Data Source
extension NumbersViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return output.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.sections[section].items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(with: ListItemTableViewCell.self)
        cell.configure(with: output.sections[indexPath.section].items[indexPath.row])
        return cell
    }
}

// MARK: - Table View Delegate
extension NumbersViewController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return output.sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Numbers View Input
extension NumbersViewController: NumbersViewInput {
    
    func showLoading() {
        if refreshControl?.isRefreshing == false {
            tableView.backgroundView = loadingIndicator
            tableView.tableFooterView = UIView()
            loadingIndicator.startAnimating()
        } else {
            tableView.backgroundView = nil
        }
    }
    
    func showData() {
        loadingIndicator.stopAnimating()
        tableView.tableFooterView = nil
        refreshControl?.endRefreshing()
        tableView.backgroundView = nil
        tableView.reloadData()
    }
    
    func show(error: Error) {
        loadingIndicator.stopAnimating()
        refreshControl?.endRefreshing()
        errorLabel.text = error.localizedDescription
        tableView.backgroundView = errorLabel
        tableView.tableFooterView = UIView()
    }
}
