//
//  AddClientVC.swift
//  CoreDataDemo
//
//  Created by Kondya on 12/05/19.
//  Copyright © 2019 Kondya. All rights reserved.
//

import UIKit
import CoreData
class AddClientVC: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
   
    var callback: ((_ id: Int) -> Void)?
    
    var client : Client?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //for update record
        if let client = client {
            self.nameText.text = client.name ?? ""
            self.phoneText.text = client.phone ?? ""
        }
    }
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
        if self.nameText.text?.trimmingCharacters(in: .whitespaces) == ""{
            LoginVC.showBottomSnackBarAlert(color: .red, message: "Please enter name", viewController: self)
        }else if self.phoneText.text?.trimmingCharacters(in: .whitespaces) == ""{
            LoginVC.showBottomSnackBarAlert(color: .red, message: "Please enter phone", viewController: self)
        }else{
            self.saveData()
        }
      
        
    }
    func saveData()  {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        if let client = client {
            client.setValue(self.nameText.text ?? "", forKey: "name")
            client.setValue(self.phoneText.text ?? "", forKey: "phone")
            client.setValue(appDelegate.userTemp, forKey: "workUnder")
        }else{
            let entity = NSEntityDescription.entity(forEntityName: "Client", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            newUser.setValue(self.nameText.text ?? "", forKey: "name")
            newUser.setValue(self.phoneText.text ?? "", forKey: "phone")
            newUser.setValue(appDelegate.userTemp, forKey: "workUnder")
        }
        
        do {
             try context.save()
            
            callback?(1)
            self.navigationController?.popViewController(animated: true)
            
        } catch {
            
            print("Failed saving")
        }
    }

    
    
}


extension AddClientVC:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
