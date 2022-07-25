//
//  ViewController.swift
//  todo
//
//  Created by Emir Sürmen on 24.07.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var todoTableView: UITableView!
    
    var todoItems: Array<String> = []
    var addItemView: UIViewController = UIViewController()
    var addItemNavController: UINavigationController = UINavigationController()
    
    @IBAction func addButtonSelected(_ sender: UIBarButtonItem) {
        self.present(addItemNavController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addItemView = self.storyboard!.instantiateViewController(withIdentifier: "AddItemViewController")
        addItemNavController = UINavigationController(rootViewController: addItemView)
        addItemNavController.transitioningDelegate = self
        
        todoTableView.dataSource = self
                
        overrideUserInterfaceStyle = .dark
                        
        // Set to empty list if there is no data
        if defaults.object(forKey: todoKey) == nil {
            defaults.set([], forKey: todoKey)
        }
        todoItems = defaults.object(forKey: todoKey) as! Array<String>
        
        todoTableView.reloadData()
    }
}


// Extension classes for todoTableView
extension ViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.isEmpty ? 1 : todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if todoItems.isEmpty {
            cell.textLabel?.text = "You don't have anything in your list!"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        } else {
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.labelSwipedLeft(sender:)))
            swipeLeft.direction = .left
            
            cell.textLabel?.text = todoItems[indexPath.row]
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
            cell.textLabel?.tag = indexPath.row
            cell.textLabel?.isUserInteractionEnabled = true
            cell.textLabel?.addGestureRecognizer(swipeLeft)
        }
        
        return cell
    }
    
    @objc func labelSwipedLeft(sender: UITapGestureRecognizer) {
        if todoItems.isEmpty {
            return
        }
        
        todoItems.remove(at: sender.view!.tag)
        defaults.set(todoItems, forKey: todoKey)
        
        todoTableView.reloadData()
    }
}

extension ViewController : UIViewControllerTransitioningDelegate {
    // Reload table view data on dismiss
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.todoItems = defaults.object(forKey: todoKey) as! Array<String>
        self.todoTableView.reloadData()
        return nil
    }
}
