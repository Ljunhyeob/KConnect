//
//  APIManager.swift
//  KConnect
//
//  Created by 이준협 on 2022/12/25.
//

import UIKit
import SwiftKeychainWrapper

class APIManager: UIViewController , NSObject{
    internal static func getAPIHeader() -> HTTPHeaders {
        var header = HTTPHeaders()
        let token: String? = KeychainWrapper.standard.string(forKey: "token")
        let authorization: String! = token
        
        header.add(name: "Authorization", value: "Bearer "+authorization!)

        return header
    }
}
