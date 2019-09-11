//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by BinhHoang on 9/8/19.
//  Copyright © 2019 BinhHoang. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryList = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategory()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath)
        cell.textLabel?.text = categoryList[indexPath.row].name
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
            destinationVC.selectedCategory = categoryList[indexPath.row]
        }
    }

    // MARK: - Table view data manipulation
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("problem with saving data \(error)")
        }
        tableView.reloadData()
    }

    func getCategory() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryList = try context.fetch(request)
        } catch {
            print("error retrieving category data \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: - Add new category
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (UIAlertAction) in
            let category = Category(context: self.context)
            category.name = textField.text!
            self.categoryList.append(category)
            self.saveCategory()
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Enter category name"
        }
        
        present(alert, animated: true, completion: nil)
    }
}
