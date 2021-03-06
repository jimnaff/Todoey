//
//  ViewController.swift
//  Todoey
//
//  Created by James Naff on 5/4/18.
//  Copyright © 2018 James Naff. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController{
    
    var todoItems: Results<Item>?
    let realm = try! Realm ()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        
        
        return cell
    
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                 
                    item.done = !item.done
                    }
            } catch {
                print("error saving status, \(error)")
            }
        }
        
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    //MARK - Add New Items
   
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user clicks on the Add Item button on our alert
            
            
            
//            let newItem = Item(context: self.context)
//
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
            
            //self.saveItems()
            
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                } catch {
                    print("error saviing new items, \(error)")
                }
            }
            
            
            self.tableView.reloadData()
            
            
            
            //newItem.parentCategory = LinkingObjects(fromType: self.selectedCategory!.self, property: newItem.title)
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            print(alertTextField.text)
            
            textField = alertTextField
        }

        alert.addAction(action)
        
        present(alert,animated: true, completion: nil)
        
        
    
    }
    
    
    
    func loadItems(){

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    
    
}

//MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate {
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
