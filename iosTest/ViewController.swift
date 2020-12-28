//
//  ViewController.swift
//  iosTest
//
//  Created by macmini on 24/12/20.
//

import UIKit
import RxSwift
import RxCocoa
import Toast_Swift

class ViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet weak var lblEMailErr: UILabel!
    @IBOutlet weak var lblPasswordError: UILabel!
    @IBOutlet weak var email751: NSLayoutConstraint!
    @IBOutlet weak var password751: NSLayoutConstraint!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    let dbObject = DBOperations()
    
    var navigate = false
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.dbObject.openDatabase()
//        self.dbObject.deleteByID()
        lblEMailErr.isHidden = true
        lblPasswordError.isHidden = true
        createViewModelBinding();
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigate = false
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    //MARK: LOGIN API
    @IBAction func btnLoginAction(_ sender: UIButton)
    {
        indicator.startAnimating()
        self.viewModel.loginUser()
        let data = self.viewModel.responseModel.asObservable().subscribe { (response) in
            print("success")
            if response.data == nil && response.error_message == nil
            {
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                }
                print(response)
                return
            }
            if response.error_message != ""
            {
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.showSimpleAlert(message: response.error_message!)
                }
                
                return
            }
            if response.data != nil
            {
                print("Success")
                if !self.navigate
                {
                    self.navigate = true
                    let err = self.dbObject.insert(name: response.data?.user?.userName ?? "", id: response.data?.user?.userId ?? 0, date: response.data?.user?.created_at ?? "")
                    
                    if err == ""
                    {
                        DispatchQueue.main.async {
                            self.indicator.stopAnimating()
                            self.emailTextField.text = ""
                            self.passwordTextField.text = ""
                            let vc = self.storyboard?.instantiateViewController(identifier: "Home") as! HomeVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            self.indicator.stopAnimating()
                            self.showSimpleAlert(message: err ?? "")
                        }
                        
                    }
                }
                
                return
            }
        } onError: { (err) in
            
            self.showSimpleAlert(message: err.localizedDescription)
        }
        data.disposed(by: disposeBag)

    }
    //MARK: VALIDATION
    func createViewModelBinding()
    {
        //EMAIL
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailIdViewModel.data)
            .disposed(by: disposeBag)
        
        let values = emailTextField.rx.text.orEmpty.asObservable().subscribe(onNext: { txt in
            print("email observe")
            if !self.viewModel.validateCredentialsEmail()
            {
                print("show error email")
                self.email751.priority = UILayoutPriority(rawValue: 748)
                self.lblEMailErr.text = self.viewModel.emailIdViewModel.errorMessage
                self.lblEMailErr.isHidden = false
                
                self.loginButton.isEnabled = false
                self.loginButton.backgroundColor = .lightGray
            }
            else
            {
                print("hide error email")
                self.email751.priority = UILayoutPriority(rawValue: 751)
                self.lblEMailErr.text = self.viewModel.emailIdViewModel.errorMessage
                self.lblEMailErr.isHidden = true
                
                if self.viewModel.validateCredentialsPassword()
                {
                    self.loginButton.isEnabled = true
                    self.loginButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
                }
                
            }
            if (self.emailTextField.text?.count == 0)
            {
                print("hide error email")
                self.email751.priority = UILayoutPriority(rawValue: 751)
                self.lblEMailErr.text = self.viewModel.emailIdViewModel.errorMessage
                self.lblEMailErr.isHidden = true
                
                self.loginButton.isEnabled = false
                self.loginButton.backgroundColor = .lightGray
            }
        })
        values.disposed(by: disposeBag)
        
        //PASSWORD
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordViewModel.data)
            .disposed(by: disposeBag)
        let values2 = passwordTextField.rx.text.orEmpty.asObservable().subscribe(onNext: { txt in
            print("password observe")
            if !self.viewModel.validateCredentialsPassword()
            {
                print("show error password")
                self.password751.priority = UILayoutPriority(rawValue: 749)
                self.lblPasswordError.text = self.viewModel.passwordViewModel.errorMessage
                self.lblPasswordError.isHidden = false
                
                self.loginButton.isEnabled = false
                self.loginButton.backgroundColor = .lightGray
            }
            else
            {
                print("hide error password")
                self.password751.priority = UILayoutPriority(rawValue: 751)
                self.lblPasswordError.text = self.viewModel.passwordViewModel.errorMessage
                self.lblPasswordError.isHidden = true
                
                if self.viewModel.validateCredentialsEmail()
                {
                    self.loginButton.isEnabled = true
                    self.loginButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
                }
            }
            if (self.passwordTextField.text?.count == 0)
            {
                print("hide error email")
                self.password751.priority = UILayoutPriority(rawValue: 751)
                self.lblPasswordError.text = self.viewModel.emailIdViewModel.errorMessage
                self.lblPasswordError.isHidden = true
                
                self.loginButton.isEnabled = false
                self.loginButton.backgroundColor = .lightGray
            }
        })
        values2.disposed(by: disposeBag)
    }
    
    func showSimpleAlert(message: String)
    {
        let alert = UIAlertController(title: "Login", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK",style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension String
{
    func convertSTringToDate() -> String
    {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dt = formatter.date(from: self)
        let myString = formatter.string(from: dt ?? Date())
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-yyyy"
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
}
