//
//  SearchTableViewController.swift
//  SearchControllerTest
//
//  Created by Daniel Hjärtström on 2018-07-23.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit

protocol CountrySelectionDelegate: class {
    func didSelectCountry(_ country: String)
}

enum Type: Int {
    case recent, filtered, unfiltered

    func title() -> String {
        switch self {
        case .recent: return "Recent"
        case .filtered: return "Results"
        case .unfiltered: return ""
        }
    }
}

class SearchTableViewController: UIViewController {
    
    weak var delegate: CountrySelectionDelegate?
    
    private lazy var searchBar: UISearchBar = {
        let temp = UISearchBar()
        temp.placeholder = "Search..."
        temp.barTintColor = UIColor.blue
        temp.returnKeyType = .search
        temp.setTextFieldApperence()
        temp.delegate = self
        view.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        return temp
    }()
    
    private lazy var tableView: UITableView = {
        let temp = UITableView(frame: CGRect.zero, style: .plain)
        temp.delegate = self
        temp.dataSource = self
        temp.tableFooterView = UIView()
        temp.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        temp.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        return temp
    }()

//    private var filteredCountries: [[String]] = []
//    private let unfilteredCountries: [[String]] = {
//        let recent = (["Sweden", "USA", "China", "Latvia"].map { $0.capitalized }).sorted()
//        let temp = (["Sweden", "Androrra", "Spain", "england", "USA", "Canada", "china", "Russia", "germany", "latvia", "France", "Thailand", "Iceland", "Bulgaria", "Netherlands", "Belgium", "Greece", "italy", "Malta"].map { $0.capitalized }).sorted()
//
//        return [recent, temp]
//    }()
    
    var countries: [Type: [String]] = {
        var temp = [Type: [String]]()
        let recent = (["Sweden", "USA", "China", "Latvia"].map { $0.capitalized }).sorted()
        let unfiltered = (["Sweden", "Androrra", "Spain", "england", "USA", "Canada", "china", "Russia", "germany", "latvia", "France", "Thailand", "Iceland", "Bulgaria", "Netherlands", "Belgium", "Greece", "italy", "Malta"].map { $0.capitalized }).sorted()
        temp[.recent] = recent
        temp[.unfiltered] = unfiltered
        temp[.filtered] = unfiltered
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.isHidden = false
        tableView.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension SearchTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text, !text.isEmpty else {
            countries[.filtered] = countries[.unfiltered]
            tableView.reloadData()
            return
        }
        countries[.filtered] = countries[.unfiltered]?.filter { return $0.hasPrefix(text) }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        countries[.filtered] = countries[.unfiltered]
        tableView.reloadData()
    }
}

extension SearchTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return [countries[.recent], countries[.filtered]].count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [countries[.recent], countries[.filtered]][section]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        cell.textLabel?.text = [countries[.recent], countries[.filtered]][indexPath.section]?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Type(rawValue: section)?.title()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let country = [countries[.recent], countries[.filtered]][indexPath.section]![indexPath.row]
        delegate?.didSelectCountry(country)
    }
}
