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
        let temp = SearchTableViewController()
        temp.delegate = self
        return temp
    }()
    
    private lazy var label: UILabel = {
        let temp = UILabel(frame: CGRect(x: view.frame.width / 2, y: view.frame.height / 2, width: 200.0, height: 70.0))
        temp.textColor = UIColor.white
        temp.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        temp.backgroundColor = UIColor.red
        return temp
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
        view.addSubview(label)
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
    
    func willDismissSearchController(_ searchController: UISearchController) {
        
    }
}

extension ViewController: CountrySelectionDelegate {
    func didSelectCountry(_ country: String) {
        label.text = country
        searchController.isActive = false
        searchController.dismiss(animated: true, completion: nil)
    }
}

