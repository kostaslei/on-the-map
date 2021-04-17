//
//  OTMClient.swift
//  On The Map
//
//  Created by Kostas Lei on 05/04/2021.
//

import Foundation

class OTMClient {
    
    
    // ENDPOINTS ENUM: Stores all of my urls as strings and then it transforms them to URL type
    enum Endpoints{
        static let base = "https://onthemap-api.udacity.com/v1"
        static let udacitySignUp = "https://auth.udacity.com/sign-up"
        
        case loginSession
        case getUsersData(String)
        case signUp
        case getStudentInformation
        case studentLocation
        case userPutInformation(String)
        
        var stringValue:String {
            switch self {
            case .loginSession: return Endpoints.base + "/session"
            case .getUsersData(let key): return Endpoints.base + "/users/" + "\(key)"
            case .signUp: return Endpoints.udacitySignUp
            case .getStudentInformation: return Endpoints.base + "/StudentLocation?order=-updatedAt&limit=100"
            case .studentLocation: return Endpoints.base + "/StudentLocation"
            case .userPutInformation(let objectID): return Endpoints.base + "/StudentLocation/" + "\(objectID)"
            }
        }
        
        var url: URL{
            return URL(string: stringValue)!
        }
    }
    
    // TASK_FOR_GET_REQUEST FUNC: It communicates with a given url and return the
    // data with a completion handler
    @discardableResult class func taskForGETRequest<ResponseType:Decodable>(url:URL,dataRefactoring: Bool, response:ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask{
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            var newData = Data()
            guard let data = data else {
                DispatchQueue.main.async{
                    completion(nil, error)
                }
                return
            }
            // Executes only when communicate with udacityAPI. Removes the first 5 Data.
            if dataRefactoring{
                let range = (5..<data.count)
                newData = data.subdata(in: range) /* subset response data! */
                print(String(data: newData, encoding: .utf8)!)
            }
            else{
                newData = data
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
                
            } catch {
                do{
                    let errorResponse = try decoder.decode(ErrorLoginResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil,errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async{
                        completion(nil, error)}
                }
            }
        }
        task.resume()
        
        return task
    }
    
    // TASK_FOR_POST_REQUEST FUNC: It encodes and send data on a given url and then
    // decodes and return the data with a completion handler
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, udacityPosting: Bool, dataRefactoring: Bool, httpMethod: String, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void){
        var newData = Data()
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        // Executes when post users data to the UdacityAPI
        if udacityPosting{
            request.addValue("application/json", forHTTPHeaderField: "Accept")}
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            // Executes only when communicate with udacityAPI. Removes the first 5 Data.
            if dataRefactoring{
                let range = (5..<data.count)
                newData = data.subdata(in: range) /* subset response data! */
                print(String(data: newData, encoding: .utf8)!)
            }
            else{
                newData = data
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
                
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorLoginResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)}
                } catch{
                    DispatchQueue.main.async {
                        completion(nil, error)}
                }
            }
        }
        task.resume()
    }
}
