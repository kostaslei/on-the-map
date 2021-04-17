//
//  LoginResponses.swift
//  On The Map
//
//  Created by Kostas Lei on 05/04/2021.
//

import Foundation

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct LoginResponse: Codable {
    let account: Account
    let session: Session
    
    enum CodingKeys: String, CodingKey{
        case account = "account"
        case session = "session"
    }
}

struct ErrorLoginResponse: Codable {
    let status:Int
    let error:String
}


extension ErrorLoginResponse:LocalizedError{
    var errorDescription: String? {
        return error
    }
}
