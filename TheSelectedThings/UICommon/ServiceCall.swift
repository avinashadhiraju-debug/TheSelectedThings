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
        
        let keys = parameter.allKeys.compactMap { $0 as? String }
        let bodyParts = keys.compactMap { key -> String? in
            guard let val = parameter.value(forKey: key) else { return nil }
            let raw = "\(val)"
            let encoded = raw.addingPercentEncoding(withAllowedCharacters: plusEncoded) ?? raw
            return "\(key)=\(encoded)"
        }
        let bodyString = bodyParts.joined(separator: "&")
        let parameterData = bodyString.data(using: .utf8) ?? Data()
        
        guard let url = URL(string: path) else {
            DispatchQueue.main.async {
                failure(NSError(domain: "ServiceCall", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL path: \(path)"]))
            }
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: 30)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

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
                        
                        debugPrint("response: " , jsonDictionary as Any)
                        
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
