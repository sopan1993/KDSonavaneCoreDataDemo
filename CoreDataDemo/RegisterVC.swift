//
//  RegisterVC.swift
//  CoreDataDemo
//
//  Created by Kondya on 12/05/19.
//  Copyright © 2019 Kondya. All rights reserved.
//

import UIKit
import CoreData
class RegisterVC: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    
    var phoneNO : String?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.phoneText.text = phoneNO ?? ""
       
        
    }
//    if !textField1.text.trimmingCharacters(in: .whitespaces).isEmpty {
//    // string contains non-whitespace characters
//    }
    @IBAction func registerBtnAction(_ sender: UIButton) {
        
        if self.nameText.text?.trimmingCharacters(in: .whitespaces) == ""{
            LoginVC.showBottomSnackBarAlert(color: .red, message: "Please enter name", viewController: self)
        }else if self.phoneText.text?.trimmingCharacters(in: .whitespaces) == ""{
            LoginVC.showBottomSnackBarAlert(color: .red, message: "Please enter phone", viewController: self)
        }else if self.emailText.text?.trimmingCharacters(in: .whitespaces) == ""{
            LoginVC.showBottomSnackBarAlert(color: .red, message: "Please enter email", viewController: self)
        }else{
            self.saveData()
        }
        
    }
    func saveData()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(self.nameText.text ?? "", forKey: "name")
        newUser.setValue(self.phoneText.text ?? "", forKey: "phone")
        newUser.setValue(self.emailText.text ?? "", forKey: "email")
        do {
            
            try context.save()
            self.navigationController?.popViewController(animated: true)
            
        } catch {
            
            print("Failed saving")
        }
    }
    
    
}


extension RegisterVC:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
