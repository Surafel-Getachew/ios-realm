//
//  TodoTableViewController.swift
//  justdoit
//
//  Created by surafel getachew on 04/01/2022.
//

import UIKit
import RealmSwift;
import SwipeCellKit;

class TodoTableViewController: UITableViewController {

    let realm = try! Realm();
    
    var todos: List<Todo>?

    var selectedCategory:Category?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData();
        
        tableView.rowHeight = 58;
        
        if let category = selectedCategory {
            self.title = category.name
        }
    }
    
    @IBAction func addTodoPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New Todo", message: "Add New Todo", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Todo"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            
            if let todoItem = alertController.textFields![0].text {
                do {
                    try self.realm.write{
                        let todo = Todo();
                        todo.name = todoItem;
                        self.selectedCategory?.todos.append(todo)
                    }
                } catch  {
                    print("Can't save todo \(error)")
                }
                self.tableView.reloadData();
            }
        }
      
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos?.count ?? 1;
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        // Configure the cell...
        cell.textLabel?.text = todos?[indexPath.row].name ?? "No Todo Item"
        
        if let todo = todos?[indexPath.row] {
            cell.accessoryType = todo.done ? .checkmark : .none
        }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let todo = todos?[indexPath.row] {
            do {
                try realm.write{
                    todo.done = !todo.done
                }
            } catch  {
                print("Error updating todo \(error)")
            }
        }
        tableView.reloadData()
    }
    
    //MARK: - Data Manipulation Method
    
    func loadData(){
        todos = selectedCategory?.todos
        tableView.reloadData();
    }
    
    func deleteTodo(todo:Todo){
        do {
            try realm.write {
                realm.delete(todo)
            }
        } catch {
            print("Error \(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK: - SwipeTableView Delegate Methods
extension TodoTableViewController:SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let todo = self.todos?[indexPath.row] {
                self.deleteTodo(todo: todo)
            }
        }

        // customize the action appearance
//        deleteAction.image = UIImage(named: "delete")
        deleteAction.image = UIImage(systemName: "trash")
        return [deleteAction]
    }
    
    
}

