//
//  ViewController.swift
//  Todoey
//
//  Created by BinhHoang on 8/16/19.
//  Copyright © 2019 BinhHoang. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
           getItemDatas()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        print("\(day)/ \(month)/ \(year)")
    }
    
    //MARK: - TableView Datasource method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "No Items added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    
//                    delete realm object
//                    realm.delete(item)
                }
            }catch {
                
            }
        }
        tableView.reloadData()
        //todoArray[indexPath.row].done = !todoArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    //MARK: - Retrieve saved items
    func getItemDatas() {

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write({
                        let newItem = Item()
                        newItem.title = textField.text!
                        
                        newItem.dateCreated = Date()
                        
                        currentCategory.items.append(newItem)
                    })
                }
                catch {
                    print("Error creating new items \(error)")
                }
            }
            self.tableView.reloadData()
       }
        
        alert.addTextField { (alertTexfield) in
            alertTexfield.placeholder = "enter todo name"
            textField = alertTexfield
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
  }
}

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            getItemDatas()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
}
