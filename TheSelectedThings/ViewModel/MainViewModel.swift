//
//  MainViewModel.swift
//  TheSelectedThings
//
//  Created by Avinash Adhiraju on 01/08/23.
//

import SwiftUI

@MainActor
class MainViewModel: ObservableObject {
    static var shared: MainViewModel = MainViewModel()
    
    @Published var txtUsername: String = ""
    @Published var txtEmail: String = ""
    @Published var txtPassword: String = ""
    @Published var isShowPassword: Bool = false
    @Published var isLoading: Bool = false
    
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var isUserLogin: Bool = false
    @Published var userObj: UserModel = UserModel(dict: [:])
    
    @Published var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "is_dark_mode") {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "is_dark_mode")
        }
    }
    
    init() {
        
        
        if( Utils.UDValueBool(key: Globs.userLogin) ) {
            // User Login
            self.setUserData(uDict: Utils.UDValue(key: Globs.userPayload) as? NSDictionary ?? [:] )
        }else{
            // User Not Login
        }
        
        #if DEBUG
        txtUsername = "user4"
        txtEmail = "test@gmail.com"
        txtPassword = "123456"
        #endif
        
    }
    
    func logout(){
        Utils.UDSET(data: false, key: Globs.userLogin)
        isUserLogin = false
    }
    
    func loginAsGuest(){
        let guestUser: [String: Any] = [
            "user_id": 999,
            "username": "Guest Curator",
            "email": "curator@selectedthings.com",
            "auth_token": "mock_guest_token"
        ]
        self.setUserData(uDict: guestUser as NSDictionary)
    }
    
    //MARK: ServiceCall
    func serviceCallLogin(){
        
        
        if(!txtEmail.isValidEmail) {
            self.errorMessage = "Please enter a valid email address"
            self.showError = true
            return
        }
        
        if(txtPassword.isEmpty) {
            self.errorMessage = "Please enter a valid password"
            self.showError = true
            return
        }
        
        self.isLoading = true
        
        ServiceCall.post(parameter: ["email": txtEmail, "password": txtPassword, "dervice_token":"" ], path: Globs.SV_LOGIN) { responseObj in
            if let response = responseObj as? NSDictionary {
                if response.value(forKey: KKey.status) as? String ?? "" == "1" {
                    self.isLoading = false
                    
                    self.setUserData(uDict: response.value(forKey: KKey.payload) as? NSDictionary ?? [:])
                    
                    
                }else{
                    self.isLoading = false
                    self.errorMessage = response.value(forKey: KKey.message) as? String ?? "Fail"
                    self.showError = true
                }
            }
        } failure: { error in
            self.isLoading = false
            self.errorMessage = error?.localizedDescription ?? "Fail"
            self.showError = true
        }

    }
    
    func serviceCallSignUp(){
        
        if(txtUsername.isEmpty) {
            self.errorMessage = "Please enter a valid username"
            self.showError = true
            return
        }
        
        
        if(!txtEmail.isValidEmail) {
            self.errorMessage = "Please enter a valid email address"
            self.showError = true
            return
        }
        
        if(txtPassword.isEmpty) {
            self.errorMessage = "Please enter a valid password (minimum 6 characters)"
            self.showError = true
            return
        }
        
        self.isLoading = true
        
        ServiceCall.post(parameter: [ "username": txtUsername , "email": txtEmail, "password": txtPassword, "dervice_token":"" ], path: Globs.SV_SIGN_UP) { responseObj in
            if let response = responseObj as? NSDictionary {
                if response.value(forKey: KKey.status) as? String ?? "" == "1" {
                    self.isLoading = false
                    self.setUserData(uDict: response.value(forKey: KKey.payload) as? NSDictionary ?? [:])
                }else{
                    self.isLoading = false
                    self.errorMessage = response.value(forKey: KKey.message) as? String ?? "Fail"
                    self.showError = true
                }
            }
        } failure: { error in
            self.isLoading = false
            self.errorMessage = error?.localizedDescription ?? "Fail"
            self.showError = true
        }

    }
    
    func setUserData(uDict: NSDictionary) {
        
        
        Utils.UDSET(data: uDict, key: Globs.userPayload)
        Utils.UDSET(data: true, key: Globs.userLogin)
        self.userObj = UserModel(dict: uDict)
        self.isUserLogin = true
        
        self.txtUsername = ""
        self.txtEmail = ""
        self.txtPassword = ""
        self.isShowPassword = false
    }
    
}
