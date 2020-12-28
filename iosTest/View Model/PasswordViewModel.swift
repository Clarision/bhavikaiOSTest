//
//  PasswordViewModel.swift
//  iosTest
//
//  Created by macmini on 24/12/20.
//

import Foundation
import RxSwift
import RxCocoa

class PasswordViewModel : ValidationViewModel {
     
    var errorMessage: String = "Password require at least 1 uppercase, 1 lowercase, and 1 number."
    
    var data: BehaviorRelay<String> = BehaviorRelay(value: "")
    var errorValue: BehaviorRelay<String?> = BehaviorRelay(value: "")
    
    func validateCredentials() -> Bool
    {
        if (data.value.rangeOfCharacter(from: CharacterSet.uppercaseLetters) == nil) || (data.value.rangeOfCharacter(from: CharacterSet.lowercaseLetters) == nil) || (data.value.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil) || data.value.count < 6
        {
            errorValue.accept(errorMessage)
            return false;
        }
        errorValue.accept("")
        return true
    }
    
    func validateLength(text : String, size : (min : Int, max : Int)) -> Bool{
        return (size.min...size.max).contains(text.count)
    }
}
