//
//  ProfileModel.swift
//  KConnect
//
//  Created by 이준협 on 2022/12/26.
//

struct ProfileModel: Codable {
    let success: Bool
    let data: DataClassProfile
}

struct DataClassProfile: Codable {
    let userID: Int
    let userName, phoneNumber, year: String
    let totalDays: Int
    let usedDays, remainDays: Double
    let group: [Group]

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case userName, phoneNumber, year, totalDays, usedDays, remainDays, group
    }
}
struct Group: Codable {
    let groupID: Int
    let groupName, roleCD: String

    enum CodingKeys: String, CodingKey {
        case groupID = "groupId"
        case groupName
        case roleCD = "roleCd"
    }
}
