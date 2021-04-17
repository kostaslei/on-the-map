//
//  LoginRequest.swift
//  On The Map
//
//  Created by Kostas Lei on 05/04/2021.
//

import Foundation

struct LoginRequest: Codable {
    let username: String
    let password: String
    
    enum CodingKeys: String,CodingKey {
        case username = "username"
        case password = "password"
    }
}

struct UdacityLoginRequest: Codable {
    let udacity: LoginRequest
}


