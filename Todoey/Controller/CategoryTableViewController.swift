//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by BinhHoang on 9/8/19.
//  Copyright © 2019 BinhHoang. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    var categoryList : Results<Category>?
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        getCategory()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath)
        cell.textLabel?.text = categoryList?[indexPath.row].name ?? "No category added yet"
        return cell
    }
    
    // MARK: - Table view delegate menthods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        context.delete(categoryList[indexPath.row])
//        categoryList.remove(at: indexPath.row)
        performSegue(withIdentifier: "goToList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryList?[indexPath.row]
        }
    }

    // MARK: - Table view data manipulation
    func saveCategory(category: Category) {
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("problem with saving data \(error)")
        }
        tableView.reloadData()
    }

    func getCategory() {
        categoryList = realm.objects(Category.self)
    }
    
    // MARK: - Add new category
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (UIAlertAction) in
            let category = Category()
            category.name = textField.text!
            self.saveCategory(category: category)
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Enter category name"
        }
        
        present(alert, animated: true, completion: nil)
    }
}
