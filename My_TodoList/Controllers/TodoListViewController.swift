//
//  ViewController.swift
//  My_TodoList
//
//  Created by Aries Lam on 3/26/19.
//  Copyright © 2019 Cuong Tran. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedIndexPath: IndexPath?
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        
        guard let colorHex = selectedCategory?.color else { fatalError() }
        
        updateNavBar(withHexCode: colorHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    //MARK - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colorHexCode: String) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
    }

    //MARK - Tableview Datasource Methods
    
    //TODO: Declare numberOfRowsInSection
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //TODO: Declare cellForRowAtIndexPath:
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath )
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Item Added"
        }

        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    
    //TODO - Declare textFieldDidSelectRowAt:
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
//                    realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print ("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen once user clicks the Add item button on our UIAlert
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print ("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model manupulate methods
    
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }

    //TODO: - swipe left to delete item
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let url = path.appendingPathComponent(item.voiceURL).path
                    realm.delete(item)
                    deleteFile(url: url)
                    realm.delete(item)
                }
            } catch {
                print ("Error delete item, \(error)")
            }
        }
    }
    
    //TODO: delete record file when item is deleted
    func deleteFile(url: String) {
        do {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: url) {
                // Delete file
                try fileManager.removeItem(atPath: url)
            } else {
                print("File does not exist at url \(url)")
            }
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
    
    //TODO: update content of item
    
    override func updateContent(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Update todo item", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Update item", style: .default) { (action) in
                //what will happen once user clicks the update
                    do {
                        try self.realm.write {
                            item.title = textField.text!
                            self.tableView.reloadData()
                        }
                    } catch {
                        print ("Error saving new items, \(error)")
                    }
                }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Update item"
                textField = alertTextField
            }
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    //TODO: swipe right to record voice
    override func recordVoice(at indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        performSegue(withIdentifier: "gotoRecord", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! RecordViewController
        if let indexPath = self.selectedIndexPath {
            if todoItems?[indexPath.row].voiceURL != "" {
                destinationVC.fileName = todoItems?[indexPath.row].voiceURL
                destinationVC.check = true
            } else {
                do {
                    try realm.write {
                        todoItems?[indexPath.row].voiceURL = "audio\(UUID().uuidString).m4a"
                        destinationVC.fileName = todoItems?[indexPath.row].voiceURL
                        destinationVC.check = false
                    }
                } catch {
                    print ("Error assign voice url, \(error)")
                }
            }
        }
    }
}


//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}

