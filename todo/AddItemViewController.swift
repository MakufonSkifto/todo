//
//  AddItemViewController.swift
//  todo
//
//  Created by Emir Sürmen on 24.07.2022.
//

import UIKit

class AddItemViewController : UIViewController {
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var contentField: UITextField!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        if !contentField.hasText {
            let alertController = UIAlertController(
                title: "Error",
                message: "You need to type something to add it to your to-do list!",
                preferredStyle: .alert
            )
            let OKAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            var data = defaults.object(forKey: "data") as! Array<String>
            data.append(contentField.text!)
            defaults.set(data, forKey: "data")
            
            self.dismiss(animated: true)
        }
    }
}
