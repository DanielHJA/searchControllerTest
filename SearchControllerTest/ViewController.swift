//
//  ViewController.swift
//  SearchControllerTest
//
//  Created by Daniel Hjärtström on 2018-07-16.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit

extension UISearchBar {
    func setTextFieldApperence() {
        if let textfield = self.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.white
                backgroundview.layer.cornerRadius = 10.0
                backgroundview.clipsToBounds = true
            }
        }
    }
    
    func textfieldForSearchBar() -> UITextField? {
        if let textfield = self.value(forKey: "searchField") as? UITextField {
            return textfield
        }
        return nil
    }
}

class ViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let temp = UITableView(frame: CGRect.zero, style: .plain)
        temp.delegate = self
        temp.dataSource = self
        temp.tableFooterView = UIView()
        
        if #available(iOS 10.0, *) {
            temp.refreshControl = refreshControl
        } else {
            temp.addSubview(refreshControl)
        }
        
       // temp.tableHeaderView = searchController.searchBar
        temp.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //temp.setContentOffset(CGPoint(x: 0, y: 44), animated: false) // Iniatally hides searchbar
        view.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        temp.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        return temp
    }()
    
    private lazy var searchResultsController: UIViewController = {
        return SearchTableViewController()
    }()
    
    private lazy var searchController: UISearchController = {
        let temp = UISearchController(searchResultsController: searchResultsController)
        //temp.dimsBackgroundDuringPresentation = false
        temp.searchBar.placeholder = "Search..."
        temp.searchBar.setTextFieldApperence()
        temp.definesPresentationContext = true
        temp.searchBar.delegate = self
        temp.delegate = self
        return temp
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let temp = UIRefreshControl()
        temp.backgroundColor = UIColor.clear
        temp.attributedTitle = NSAttributedString(string: "Reloading...")
        temp.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        temp.tintColor = UIColor.black
        return temp
    }()
    
    private var filteredCountries: [String] = []
    private let unfilteredCountries: [String] = {
        let temp = ["Sweden", "Androrra", "Spain", "england", "USA", "Canada", "china", "Russia", "germany", "latvia", "France", "Thailand", "Iceland", "Bulgaria", "Netherlands", "Belgium", "Greece", "italy", "Malta"]
        return (temp.map { $0.capitalized }).sorted()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationItem.searchController = searchController
        tableView.reloadData()
        filteredCountries = unfilteredCountries
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func handleRefresh(_ sender: UIRefreshControl){
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl.endRefreshing()
        }
    }
    
}

extension ViewController: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            searchController.searchResultsController?.view.isHidden = false
        }
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text, !text.isEmpty else {
            filteredCountries = unfilteredCountries
            tableView.reloadData()
            return
        }
        filteredCountries = unfilteredCountries.filter { return $0.hasPrefix(text) }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredCountries = unfilteredCountries
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        cell.textLabel?.text = filteredCountries[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
}

