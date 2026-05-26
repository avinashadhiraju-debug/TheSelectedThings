//
//  ServiceCall.swift
//  TheSelectedThings
//
//  Created by Avinash Adhiraju on 01/08/23.
//

import SwiftUI
import UIKit

class ServiceCall {
    
    class func post(parameter: NSDictionary, path: String, isToken: Bool = false, withSuccess: @escaping ( (_ responseObj: AnyObject?) -> () ), failure: @escaping ( (_ error: Error?) -> () ) ) {
        
        let plusEncoded = CharacterSet.urlQueryAllowed.subtracting(.init(charactersIn: "+"))
        let bodyString = (parameter.allKeys as! [String]).map { key -> String in
            let raw = "\(parameter.value(forKey: key)!)"
            let encoded = raw.addingPercentEncoding(withAllowedCharacters: plusEncoded) ?? raw
            return "\(key)=\(encoded)"
        }.joined(separator: "&")
        let parameterData = bodyString.data(using: .utf8) ?? Data()
        
        var request = URLRequest(url: URL(string: path)!,timeoutInterval: 20)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30

        if(isToken) {
            let userDict = Utils.UDValue(key: Globs.userPayload) as? NSDictionary ?? [:]
            let authToken = userDict.value(forKey: "auth_token") as? String ?? ""
            request.addValue( authToken , forHTTPHeaderField: "access_token")
        }
        request.httpMethod = "POST"
        request.httpBody = parameterData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          
            if let error = error {
                DispatchQueue.main.async {
                    failure(error)
                }
            }else{
                
                if let data = data {
                    do {
                        let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                        
                        debugPrint("response: " , jsonDictionary )
                        
                        DispatchQueue.main.async {
                            withSuccess(jsonDictionary)
                        }
                        
                        
                    }
                    catch {
                        DispatchQueue.main.async {
                            failure(error)
                        }
                    }
                }
               
            
            }
        }

        task.resume()
        
    }
    
}
