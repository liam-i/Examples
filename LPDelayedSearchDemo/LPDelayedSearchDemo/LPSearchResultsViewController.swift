//
//  LPSearchResultsViewController.swift
//  LPDelayedSearchDemo
//
//  Created by pengli on 2018/5/22.
//  Copyright © 2018年 pengli. All rights reserved.
//

import UIKit
import LPDelayedSearch

class LPSearchResultsViewController: UITableViewController {
    
    deinit {
        print("LPSearchResultsViewController: -> release memory.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func setPerformSearch(with searchBar: UISearchBar) {
        searchBar.delegate = self
        
        searchBar.performSearch(afterDelay: 1.0) { (text) in
            print("performSearch：text=\(String(describing: text))")
        }
    }
}

extension LPSearchResultsViewController {
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

extension LPSearchResultsViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {

    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.performSearchNow()
        
        print("performSearchNow=\(String(describing: text))")
    }
}
