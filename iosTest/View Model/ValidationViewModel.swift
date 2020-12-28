//
//  ValidationViewModel.swift
//  iosTest
//
//  Created by macmini on 24/12/20.
//

import Foundation
import RxSwift
import RxCocoa

protocol ValidationViewModel {
     
    var errorMessage: String { get }
    
    // Observables
    var data: BehaviorRelay<String> { get set }
    var errorValue: BehaviorRelay<String?> { get}

    
    // Validation
    func validateCredentials() -> Bool
} 
