//
//  LoginViewModel.swift
//  iosTest
//
//  Created by macmini on 24/12/20.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    let model : LoginModel = LoginModel()
    let disposebag = DisposeBag()
    let apiCall = APIService()
    var responseModel : BehaviorRelay<LoginModelResponse> = BehaviorRelay(value: LoginModelResponse(data: nil, error_message: "", result: nil))
    
    // Initialise ViewModel's
    let emailIdViewModel = EmailIdViewModel()
    let passwordViewModel = PasswordViewModel()
    
    // Fields that bind to our view's
    let isSuccess : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let isLoading : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let errorMsg : BehaviorRelay<String> = BehaviorRelay(value: "")

    
    func validateCredentialsEmail() -> Bool{
        return emailIdViewModel.validateCredentials()
    }
    
    func validateCredentialsPassword() -> Bool{
        return passwordViewModel.validateCredentials();
    }
    
    func loginUser()
    {
        self.model.email = self.emailIdViewModel.data.value
        self.model.password = self.passwordViewModel.data.value
        
        self.isLoading.accept(true)
        let request =  APIService()
        request.parameters = ["email":self.model.email , "password":self.model.password]
        let result = APICalling().send(apiRequest: request)
        print(result)
        
        let value = result.bind { (model) in
            print(model)
            self.responseModel.accept(model)
        }
        value.disposed(by: self.disposebag)
    }
}
