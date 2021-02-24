//
//  ViewController.swift
//  Project7
//
//  Created by Frank Solleveld on 24/02/2021.
//

import UIKit

class ViewController: UITableViewController {
    // MARK: Customer Variables
    var petitions = [Petition]()
    let testString = "https://www.hackingwithswift.com/samples/petitions-1.json"
    let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
    }
    
    // MARK: Custom Methods
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        } else if let url = URL(string: testString) {
            print("Live URL broken, using test JSON.")
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
    }
    
    // MARK: Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

