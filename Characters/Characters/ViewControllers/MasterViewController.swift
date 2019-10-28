//
//  MasterViewController.swift
//  Characters
//
//  Created by Sujananth Visvaratnam on 26/10/19.
//  Copyright © 2019 Sujananth. All rights reserved.
//

import UIKit


private let kUnkownError = "Unkown Error Occured"
private let kDetailSegueID = "showDetail"
private let kCharacterCellID = "Cell"

class MasterViewController: UIViewController {

    var detailViewController: DetailViewController? = nil
    private var charactersList: [Character] = []
    private var filteredCharacterList: [Character] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private var isSearchOn: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        prepareCharacters()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.returnKeyType = .done
        clearSelection()
    }
    
    /*
     A method to download and display data from API
     */
    private func prepareCharacters() {
        UseCase.shared.getCharacters { (error, charactersModel) in
            guard error == nil else {
                self.showAlertWith(description: error?.localizedDescription ?? kUnkownError)
                return
            }
            self.charactersList = charactersModel?.characters ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func showAlertWith(description: String) {
        let errorAlert = UIAlertController(title: "Error", message: description, preferredStyle: UIAlertController.Style.alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(errorAlert, animated: true, completion: nil)
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kDetailSegueID {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = isSearchOn ? filteredCharacterList[indexPath.row] : charactersList[indexPath.row]
                if let controller = (segue.destination as! UINavigationController).topViewController as? DetailViewProtocol {
                    controller.character = object
                    controller.detailViewTapDelegate = self
                    controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
            }
        }
    }
    
    private func clearSelection() {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    /*
     A method to load data in table view based on user entered text in search bar.
     */
    private func filterCharactersFor(_ searchText: String) {
        filteredCharacterList = charactersList.filter { character in
            let stringMatch = character.detail?.lowercased().range(of: searchText.lowercased())
            return stringMatch != nil ? true : false
        }
    }
    
}

extension MasterViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchOn ? filteredCharacterList.count : charactersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCharacterCellID, for: indexPath)
        
        let object = isSearchOn ? filteredCharacterList[indexPath.row] : charactersList[indexPath.row]
        cell.textLabel!.text = object.getCharacterName()
        return cell
    }
    
}

/*
 An extension to handle table view delegate
 */
extension MasterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.resignFirstResponder()
    }
}

/*
 An extension to handle search bar delegate
 */
extension MasterViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isSearchOn = false
        } else {
            isSearchOn = true
            filterCharactersFor(searchText)
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

/*
 An extension to hadnle Detail view tap protocl
 */
extension MasterViewController: DetailViewTapProtocol {
    func dismissKeyboardOnTap() {
        self.searchBar.resignFirstResponder()
    }
}
  
