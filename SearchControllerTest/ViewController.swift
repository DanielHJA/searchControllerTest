//
//  ViewController.swift
//  SearchControllerTest
//
//  Created by Daniel Hjärtström on 2018-07-16.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var searchResultsController: UIViewController = {
        return SearchTableViewController()
    }()
    
    private lazy var searchController: UISearchController = {
        let temp = UISearchController(searchResultsController: searchResultsController)
        //temp.dimsBackgroundDuringPresentation = false
        temp.searchBar.placeholder = "Search..."
        temp.searchBar.setTextFieldApperence()
        temp.definesPresentationContext = true
        temp.delegate = self
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = UIColor.white
        navigationItem.searchController = searchController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension ViewController: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            searchController.searchResultsController?.view.isHidden = false
        }
    }
}

