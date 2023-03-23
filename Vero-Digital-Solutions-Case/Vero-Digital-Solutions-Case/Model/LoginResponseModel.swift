//
//  LoginResponseModel.swift
//  Vero-Digital-Solutions-Case
//
//  Created by Ali Görkem Aksöz on 23.03.2023.
//

import Foundation

// MARK: - LoginResponseModel
struct LoginResponseModel: Codable {
    let oauth: Oauth?
    let userInfo: UserInfo?
    let apiVersion: String?
    let showPasswordPrompt: Bool?
}

// MARK: - Oauth
struct Oauth: Codable {
    let accessToken: String?
    let expiresIn: Int?
    let tokenType: String?
    let scope: JSONNull?
    let refreshToken: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case scope
        case refreshToken = "refresh_token"
    }
}

// MARK: - UserInfo
struct UserInfo: Codable {
    let personalNo: Int?
    let firstName, lastName, displayName: String?
    let active: Bool?
    let businessUnit: String?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
