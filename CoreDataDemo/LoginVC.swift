//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Kondya on 12/05/19.
//  Copyright © 2019 Kondya. All rights reserved.
//

import UIKit
import CoreData
class LoginVC: UIViewController {

    @IBOutlet weak var phoneText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.phoneText.delegate = self
    }

    @IBAction func loginBtnAction(_ sender: UIButton) {
    
        

        if self.phoneText.text?.trimmingCharacters(in: .whitespaces) == ""{
            
            LoginVC.showBottomSnackBarAlert(color: .red, message: "Please enter phone", viewController: self)
            
        }else{
            checkUser()
        }
        
        
    }
    func checkUser()  {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            if let users = result as? [User] {
                
                if !users.isEmpty {
                    
                    let tempUser = users.filter( {$0.phone == self.phoneText.text ?? "" })
                    
                    if !tempUser.isEmpty {
                        
                        appDelegate.userTemp = tempUser[0]
                        self.isRegister(value: true)
                        
                    }else{
                        self.isRegister(value: false)
                    }
                    
                    
                }
                else{
                    self.isRegister(value: false)
                }
                
            }
        } catch {
            
            print("Failed")
        }

    }
    
    func isRegister(value:Bool)  {
        if value {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardVC") as? DashBoardVC {
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        else{
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC {
                
               
                vc.phoneNO = self.phoneText.text ?? "";
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
    }
    
}








extension LoginVC:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



extension LoginVC {
    
    class func showBottomSnackBarAlert(color : UIColor , message : String, viewController:UIViewController)
    {
        let fontColor : UIColor!
        if color == UIColor.red
        {
            fontColor = UIColor.white
        }
        else if color == UIColor.green
        {
            fontColor = UIColor.black
        }
        else if color == UIColor.yellow
        {
            fontColor = UIColor.black
        }
        else
        {
            fontColor = UIColor.black
        }
        
        let attributedString = NSAttributedString(string: "\(message)", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: fontColor ?? UIColor.black
            ])
        
        DispatchQueue.main.async(execute: {() -> Void in
            let alert = UIAlertController(title: nil , message: "", preferredStyle: .actionSheet)
            alert.setValue(attributedString, forKey: "attributedMessage")
            
            
            for vi in  (((alert.view.subviews.first)?.subviews.first)?.subviews
                )!
            {
                vi.backgroundColor = color
                
            }
            
            viewController.present(alert, animated: true, completion:nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                viewController.dismiss(animated: true, completion: nil)
            };
        })
    }
}
