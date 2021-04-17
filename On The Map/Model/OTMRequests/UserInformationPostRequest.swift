//
//  PostStudentDataRequest.swift
//  On The Map
//
//  Created by Kostas Lei on 08/04/2021.
//

import Foundation

struct UserInformationPostRequest: Codable{
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
