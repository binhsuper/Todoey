//
//  ViewController.swift
//  Todoey
//
//  Created by BinhHoang on 8/16/19.
//  Copyright © 2019 BinhHoang. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    
    var todoArray = [Item]()
    let defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getItemDatas()
    }
    
    //MARK - TableView Datasource method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = todoArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        todoArray[indexPath.row].done = !todoArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        saveItemDatas()
    }
    
    //MARK - Save all new items
    func saveItemDatas() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.todoArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding data, \(error)")
        }
        self.tableView.reloadData()
    }
    
    //MARK - Retrieve saved items
    func getItemDatas() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                self.todoArray = try decoder.decode([Item].self, from: data)
            }catch {
                print("error retrieving items \(error)")
            }
        }
    }

    
    //MARK - Add new items
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            let newItem = Item()
            if textField.text == "" {
                newItem.title = "New item"
            }
            else {
                newItem.title = textField.text!
            }
            self.todoArray.append(newItem)
            
            self.saveItemDatas()
        }
        
        alert.addTextField { (alertTexfield) in
            alertTexfield.placeholder = "enter todo name"
            textField = alertTexfield
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
}

