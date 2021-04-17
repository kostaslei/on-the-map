//
//  ParseResponse.swift
//  On The Map
//
//  Created by Kostas Lei on 06/04/2021.
//

import Foundation

struct StudentInformation: Codable{
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    let mediaURL: String
    
}

struct StudentInformationResponse: Codable {
    let studentInformationResults: [StudentInformation]

    
    enum CodingKeys: String, CodingKey{
        case studentInformationResults = "results"
    }
    
}


