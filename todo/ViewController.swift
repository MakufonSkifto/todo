//
//  ViewController.swift
//  todo
//
//  Created by Emir Sürmen on 24.07.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var todoTableView: UITableView!
    
    let defaults = UserDefaults.standard
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
        todoTableView.delegate = self
                
        overrideUserInterfaceStyle = .dark
        
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Add the label if there is data
        if defaults.object(forKey: "data") == nil {
            defaults.set([], forKey: "data")
                        
            let label = emptyListLabel()
            self.view.addSubview(label)
            
            let margins = self.view.layoutMarginsGuide
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            ])
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalToSystemSpacingBelow: self.view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0),
                label.bottomAnchor.constraint(equalToSystemSpacingBelow: label.bottomAnchor, multiplier: 1.0)
            ])
        } else {
            todoItems = defaults.object(forKey: "data") as! Array<String>
        }
    }
    
    func emptyListLabel() -> UIView {
        let label = UILabel(
            frame: CGRect(x: 0, y: 0, width: 400, height: 21)
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You don't have anything in your list!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        
        return label
    }
}


// Extension classes for todoTableView
extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.labelSwipedLeft(sender:)))
        swipeLeft.direction = .left
        
        cell.textLabel?.text = todoItems[indexPath.row]
        cell.textLabel?.tag = indexPath.row
        cell.textLabel?.isUserInteractionEnabled = true
        cell.textLabel?.addGestureRecognizer(swipeLeft)
        
        return cell
    }
    
    @objc func labelSwipedLeft(sender: UITapGestureRecognizer) {
        todoItems.remove(at: sender.view!.tag)
        
        defaults.set(todoItems, forKey: "data")
        
        todoTableView.reloadData()
    }
}

extension ViewController : UIViewControllerTransitioningDelegate {
    // Reload table view data on dismiss
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.todoItems = defaults.object(forKey: "data") as! Array<String>
        self.todoTableView.reloadData()
        return nil
    }
}
