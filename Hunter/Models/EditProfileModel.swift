//
//  EditProfileModel.swift
//  Bazar
//
//  Created by iOSayed on 17/06/2023.
//

import Foundation
// MARK: - EditProfileModel
//struct EditProfileModel: Codable {
//    let message: String?
//    let data: EditProfileData?
//}
struct EditProfileModel: Decodable {
    let message: MessageType?
    let data: EditProfileData?
    let success: Bool?
    let statusCode: Int?

    enum MessageType {
        case single(String)
        case multiple([String])
    }

    enum CodingKeys: String, CodingKey {
        case message, data, success, statusCode
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        statusCode = try container.decode(Int.self, forKey: .statusCode)

        // Custom decoding for the 'message' field
        if let messageString = try? container.decode(String.self, forKey: .message) {
            message = .single(messageString)
        } else if let messageArray = try? container.decode([String].self, forKey: .message) {
            message = .multiple(messageArray)
        } else {
            message = nil
        }

        data = try container.decodeIfPresent(EditProfileData.self, forKey: .data)
    }
}

// MARK: - DataClass
struct EditProfileData: Codable {
    let id: Int?
    let name, lastName, username, pass: String?
    let loginMethod, uid, bio, mobile: String?
    let email, countryID, cityID, regionID: String?
    let pic, cover, regid: String?
    let verified, blocked, codeVerify, notification: Int?
    let deactivate: Int?
    let note, passV: String?
    let createdAt: String?
    

    enum CodingKeys: String, CodingKey {
        case id, name
        case lastName = "last_name"
        case username, pass
        case loginMethod = "login_method"
        case uid, bio, mobile, email
        case countryID = "country_id"
        case cityID = "city_id"
        case regionID = "region_id"
        case pic, cover, regid, verified, blocked
        case codeVerify = "code_verify"
        case notification, deactivate, note
        case passV = "pass_v"
        case createdAt = "created_at"
    }
}
