//
//  HomeVC.swift
//  iosTest
//
//  Created by macmini on 28/12/20.
//

import UIKit


class HomeVC: UIViewController
{

    let dbObject = DBOperations()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        dbObject.openDatabase()
        dbObject.read()
        
    }
    
    @IBAction func btnLogoutAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}
