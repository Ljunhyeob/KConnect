//
//  LoginModel.swift
//  KConnect
//
//  Created by 이준협 on 2022/12/24.
//

struct LoginModel: Codable {
    let success: Bool
    let data: DataClass
}

struct DataClass: Codable {
    let dataInit: Bool
    let token: String

    enum CodingKeys: String, CodingKey {
        case dataInit = "init"
        case token
    }
}
