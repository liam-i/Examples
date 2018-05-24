//
//  LPSearchViewController.swift
//  LPDelayedSearchDemo
//
//  Created by pengli on 2018/5/22.
//  Copyright © 2018年 pengli. All rights reserved.
//

import UIKit

class LPSearchViewController: UITableViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    lazy var resultsViewController = LPSearchResultsViewController(style: .grouped)
    lazy var searchController: UISearchController = {
        return UISearchController(searchResultsController: self.resultsViewController)
    }()
    
    deinit {
        print("LPSearchViewController: -> release memory.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = resultsViewController
        searchController.view.backgroundColor = UIColor.clear
        searchController.searchBar.backgroundColor = UIColor.clear
        searchController.searchBar.placeholder = "搜索"
        searchController.searchBar.tintColor = UIColor(red: 34.0 / 255, green: 34.0 / 255, blue: 34.0 / 255, alpha: 1.0)
        searchController.searchBar.barTintColor = UIColor(red: 246.0 / 255, green: 246.0 / 255, blue: 246.0 / 255, alpha: 0.95)
        searchController.searchBar.layer.borderColor = UIColor(red: 246.0 / 255, green: 246.0 / 255, blue: 246.0 / 255, alpha: 0.95).cgColor
        searchController.searchBar.layer.borderWidth = 2
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        searchController.delegate = self
        
        definesPresentationContext = true
        
        resultsViewController.setPerformSearch(with: searchController.searchBar)
        
        
        textField.performSearch(afterDelay: 1.0) { (text) in
            print("performSearch：text=\(String(describing: text))")
        }
        
        textView.performSearch(afterDelay: 1.0) { (text) in
            print("performSearch：text=\(String(describing: text))")
        }
    }
}

extension LPSearchViewController {
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        return cell
    }
}

extension LPSearchViewController: UISearchControllerDelegate {
    
    // MARK: - UISearchControllerDelegate
    
    func presentSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
}

