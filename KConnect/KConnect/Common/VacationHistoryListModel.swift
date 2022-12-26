//
//  VacationHistoryListModel.swift
//  KConnect
//
//  Created by 이준협 on 2022/12/26.
//


//연차 사용 내역 저장하는 모델

struct VacationHistoryListModel: Codable {
    let success: Bool
    let data: VacationHistoryDataClass
}

// MARK: - DataClass
struct VacationHistoryDataClass: Codable {
    let content: [Content]
    let pageable: Pageable
}

// MARK: - Content
struct Content: Codable {
    let vacationID, userID: Int
    let userName, vacationType, startDate, endDate: String
    let days: Double
    let comment, statusType: String
    let denyReason: String?
    let createDt: String

    enum CodingKeys: String, CodingKey {
        case vacationID = "vacationId"
        case userID = "userId"
        case userName, vacationType, startDate, endDate, days, comment, statusType, denyReason, createDt
    }
}

// MARK: - Pageable
struct Pageable: Codable {
    let totalPages, totalElements, page: Int
}
