//
//  ItemsModel.swift
//  Vero-Digital-Solutions-Case
//
//  Created by Ali Görkem Aksöz on 23.03.2023.
//

import Foundation

struct ItemsModel: Codable {
    let responseModel: [ItemsModelElement]
}

// MARK: - ItemsModelElement
struct ItemsModelElement: Codable {
    let task, title, descriptionn, sort: String?
    let wageType, businessUnitKey, businessUnit, parentTaskID: String?
    let preplanningBoardQuickSelect: String?
    let colorCode: String?
    let workingTime: String?
    let isAvailableInTimeTrackingKioskMode: Bool?

    enum CodingKeys: String, CodingKey {
        case task, title, sort, wageType
        case descriptionn = "description"
        case businessUnitKey = "BusinessUnitKey"
        case businessUnit, parentTaskID, preplanningBoardQuickSelect, colorCode, workingTime, isAvailableInTimeTrackingKioskMode
    }
}
