//
//  ViewController.swift
//  Project7
//
//  Created by Frank Solleveld on 24/02/2021.
//

/*
 CHALLENGE TIME
 2. Modify project 8 so loading levels is done in the background. Make sure you update your UI on the main thread!
 3. Modify your project 7 so that your filtering takes place in the background.
 */

import UIKit

class ViewController: UITableViewController, UISearchResultsUpdating {
    
    // MARK: Customer Variables
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var urlString = String()
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    // MARK: Custom Methods
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func fetchJSON(){
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed. Check your internet connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @IBAction func creditsBtnPressed(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Credits", message: "This data is collected from whitehouse.gov.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count == 0 {
            filteredPetitions.removeAll()
            tableView.reloadData()
        } else if text.count > 2 {
            for item in petitions {
                if item.title.contains(text) || item.body.contains(text) {
                    if !filteredPetitions.contains(where: {$0.title == item.title}) {
                        filteredPetitions.append(item)
                    }
                }
            }
            tableView.reloadData()
        }
    }
    
    // MARK: Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredPetitions.count > 0 {
            return filteredPetitions.count
        } else {
            return petitions.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var petition: Petition
        if filteredPetitions.count > 0 {
            petition = filteredPetitions[indexPath.row]
        } else {
            petition = petitions[indexPath.row]
        }
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        if filteredPetitions.count > 0 {
            vc.detailItem = filteredPetitions[indexPath.row]
        } else {
            vc.detailItem = petitions[indexPath.row]
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
