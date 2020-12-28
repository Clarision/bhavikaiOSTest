//
//  LoginModel.swift
//  iosTest
//
//  Created by macmini on 24/12/20.
//

import Foundation

class LoginModel {
    
    var email = ""
    var password = ""
    
    convenience init(email : String, password : String) {
        self.init()
        self.email = email
        self.password = password
    }
}

struct LoginModelResponse: Codable
{
    let data: UserModel?
    let error_message: String?
    let result: Int?
    
    private enum CodingKeys: String, CodingKey {
        case data
        case error_message
        case result
    }
}
struct UserModel: Codable
{
    let user: UserDetailModel?
    
    private enum CodingKeys: String, CodingKey {
        case user
    }
}
struct UserDetailModel: Codable
{
    let userName : String?
    let userId: Int?
    let created_at : String?
    
    private enum CodingKeys: String, CodingKey {
        case userName
        case userId
        case created_at
    }
}
class UserListModel
{
    let userName : String?
    let userId: Int?
    let created_at : String?
    
    init(userId:Int, userName:String, created_at: String)
    {
        self.userName = userName
        self.userId = userId
        self.created_at = created_at
    }
}


