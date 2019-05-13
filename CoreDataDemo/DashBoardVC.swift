//
//  DashBoardVC.swift
//  CoreDataDemo
//
//  Created by Kondya on 12/05/19.
//  Copyright © 2019 Kondya. All rights reserved.
//

import UIKit
import CoreData
class DashBoardVC: UIViewController {

    
    var clientDataArray : [Client] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.getDataFromDb()
    }
  
    
    func getDataFromDb()  {
        
        self.clientDataArray = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let clients = appDelegate.userTemp?.has?.allObjects as? [Client] {
            self.clientDataArray = clients
        }
        self.tableView.reloadData()
        
    }

    @IBAction func addButtonAction(_ sender: Any) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddClientVC") as? AddClientVC {
            vc.callback = { (id) -> Void in
                print("callback")
                self.getDataFromDb()
               
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
}


extension DashBoardVC : UITableViewDelegate,UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.clientDataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "CustomDashCell") as? CustomDashCell {
            
            let temp = self.clientDataArray[indexPath.row]
            cell.phoneLbl.text = temp.phone ?? ""
            cell.nameLbl.text = temp.name ?? ""
            return cell
            
        }
        else {
            return UITableViewCell()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // action one
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            
            let temp = self.clientDataArray[indexPath.row]
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddClientVC") as? AddClientVC {
                vc.client = temp
                
                vc.callback = { (id) -> Void in
                    print("callback")
                    self.getDataFromDb()
                    
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
            
        })
        editAction.backgroundColor = UIColor.blue
        
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            let temp = self.clientDataArray[indexPath.row]
            self.deleteObject(client: temp)
            

            
            
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [editAction, deleteAction]
    }
    
   
   
    
    func deleteObject(client:Client) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(client)
        do {
            
            try context.save()
            self.getDataFromDb()
            
        } catch {
            
            print("Failed saving")
        }
        
    }

}
