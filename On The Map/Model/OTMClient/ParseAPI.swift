//
//  ParseAPI.swift
//  On The Map
//
//  Created by Kostas Lei on 06/04/2021.
//

import Foundation

class ParseAPI{
    
    // GET_PARSE_DATA FUNC: Requests the data of the last 100 users and if succeds
    // then return them, else returns empty array
    class func getStudentInformation(completion: @escaping ([StudentInformation],Error?) -> Void) {
        OTMClient.taskForGETRequest(url: OTMClient.Endpoints.getStudentInformation.url, dataRefactoring: false, response: StudentInformationResponse.self) { (response, error) in
            if let response = response {
                DispatchQueue.main.async {
                    completion(response.studentInformationResults,nil)
                }
            }
            else {
                DispatchQueue.main.async {
                    completion([],error)
                }
            }
        }
    }
    
    // Post users location and url to udacity server
    class func userPostInformation(completion: @escaping (Bool, Error?) -> Void){
        OTMClient.taskForPOSTRequest(url: OTMClient.Endpoints.studentLocation.url, udacityPosting: false, dataRefactoring: false, httpMethod: "POST", responseType: UserInformationPostResponse.self, body: UserInformationPostRequest(uniqueKey: AppData.uniqueKey, firstName: AppData.firstName, lastName: AppData.lastName, mapString: AppData.mapString, mediaURL: AppData.mediaUrL, latitude: AppData.latitude, longitude: AppData.longtitude)) { (response, error) in
            if let response = response{
                AppData.objectId = response.objectId
                completion(true,nil)
            }
            else {
                completion(false,error)
            }
        }
    }
    
    // Overwrite users location on udacity server
    class func userPutInformation(completion: @escaping (Bool, Error?) -> Void){
        OTMClient.taskForPOSTRequest(url: OTMClient.Endpoints.userPutInformation(AppData.objectId!).url, udacityPosting: false, dataRefactoring: false, httpMethod: "PUT", responseType: UserInformationPutResponse.self, body: UserInformationPostRequest(uniqueKey: AppData.uniqueKey, firstName: AppData.firstName, lastName: AppData.lastName, mapString: AppData.mapString, mediaURL: AppData.mediaUrL, latitude: AppData.latitude, longitude: AppData.longtitude)) { (response, error) in
            if let response = response{
                completion(true,nil)
            }
            else {
                completion(false,error)
            }
        }
    }
    
}
