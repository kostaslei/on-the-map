//
//  UdacityAPI.swift
//  On The Map
//
//  Created by Kostas Lei on 10/04/2021.
//

import Foundation

class UdacityAPI{
    
    // LOGIN FUNC: Checks if the user exists in Udacity API database
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void){
        OTMClient.taskForPOSTRequest(url: OTMClient.Endpoints.loginSession.url, udacityPosting: true, dataRefactoring: true, httpMethod: "POST", responseType: LoginResponse.self, body: UdacityLoginRequest(udacity: LoginRequest(username: username, password: password))) { (response, error) in
            if let response = response {
                AppData.uniqueKey = response.account.key
                completion(true,nil)
            }
            else {
                completion(false,error)
            }
        }
    }
    
    // LOGOUT FUNC: Logout the user from the app and erases the stored data
    class func logout(completion: @escaping () -> Void){
        var request = URLRequest(url: OTMClient.Endpoints.loginSession.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            // Erase the stored data
            AppData.uniqueKey = ""
            AppData.firstName = ""
            AppData.lastName = ""
            AppData.latitude = 0
            AppData.longtitude = 0
            AppData.mapString = ""
            AppData.mediaUrL = ""
            AppData.parseDataResults = []
            completion()
        }
        task.resume()
    }
    
    // GET_USERS_DATA FUNC: Uses the uniqueKey in the url in order to download some of the users data
    class func getUsersData() {
        let request = URLRequest(url: OTMClient.Endpoints.getUsersData(AppData.uniqueKey).url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                print(error!)
                return
            }
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            
            // Use jsonSerialization in order to get the first and last name from the data
            do{
                let json = try JSONSerialization.jsonObject(with: newData!, options: []) as! [String:Any]
                AppData.firstName = json["first_name"] as! String
                AppData.lastName = json["last_name"] as! String
            }catch{
                print(error)}
        }
        task.resume()
    }
}
