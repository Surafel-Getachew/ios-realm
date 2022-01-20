//
//  CategoryTableViewController.swift
//  justdoit
//
//  Created by surafel getachew on 04/01/2022.
//
import UIKit
import RealmSwift
import SwipeCellKit

class CategoryTableViewController: UITableViewController {
 

//    var Categories:[String] = ["Home","Office","Travel","For Fun","Misc"];
    var Categories:Results<Category>?
    var selectedIndex:Int?
    let realm = try! Realm();
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 58;
        print("User Realm User file location: \(realm.configuration.fileURL!.path)")
        loadData();
    }
    
    
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New Category", message: "Add new category", preferredStyle: .alert);
        
        alertController.addTextField { textField in
            textField.placeholder = "Category"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            let inputValue = alertController.textFields![0].text
            let category = Category()
            if let categoryName = inputValue {
                category.name = categoryName
            }
            self.saveData(category: category)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "goToTodoItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTodoItems" {
            if let destinationVC = segue.destination as? TodoTableViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
//                    destinationVC.selectedCategory = Categories?[indexPath.row].name
                    destinationVC.selectedCategory = Categories?[indexPath.row]
                    
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Categories?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! SwipeTableViewCell
       cell.delegate = self
        cell.textLabel?.text = Categories?[indexPath.row].name
        return cell
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    //MARK: - Data Manipulation Method
    func loadData() {
        Categories = realm.objects(Category.self);
        tableView.reloadData();
    }
    
    func saveData(category:Category){
        do {
            try realm.write{
                realm.add(category)
            }
        } catch  {
            print("Error\(error)")
        }
        tableView.reloadData()
    }
    
    func deleteData(category:Category){
        do {
            try realm.write {
                realm.delete(category)
            }
        } catch {
            print("Error \(error)")
        }
        tableView.reloadData();
    }

}

extension CategoryTableViewController:SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            let categoryToBeDeleted = self.Categories?[indexPath.row]
            if let category = categoryToBeDeleted {
                self.deleteData(category: category)
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(systemName: "trash")
        
        return [deleteAction]
    }
}

