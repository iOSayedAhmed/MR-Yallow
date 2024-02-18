//
//  VerificationCodeModel.swift
//  NewBazar
//
//  Created by iOSAYed on 08/01/2024.
//

import Foundation

// MARK: - VerificationCodeModel
struct VerificationCodeModel: Codable {
    let message: String?
    let data: UserData?
    let success: Bool?
    let statusCode: Int?
}

// MARK: - DataClass
struct UserData: Codable {
    let id: Int?
    let name, username, pass, loginMethod: String?
    let uid, bio, mobile, email: String?
    let countryID, cityID, regionID: Int?
    let pic: String?
    let cover, regid: String?
    let typeMob: String?
    let verified, blocked, codeVerify, notification: Int?
    let deactivate: Int?
    let note: String?
    let passV: String?
    let activationCode, isAdvertiser: Int?
    let createdAt, updatedAt: String?
    let deletedAt, planID: String?
    let verifyRequest, acceptedLogin: Int?
    let isStore: Bool?
    let availableAdsCountUserInCurrentMonth, availableAdsCountStoreInCurrentMonth: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, username, pass
        case loginMethod = "login_method"
        case uid, bio, mobile, email
        case countryID = "country_id"
        case cityID = "city_id"
        case regionID = "region_id"
        case pic, cover, regid
        case typeMob = "type_mob"
        case verified, blocked
        case codeVerify = "code_verify"
        case notification, deactivate, note
        case passV = "pass_v"
        case activationCode = "activation_code"
        case isAdvertiser = "is_advertiser"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case planID = "plan_id"
        case verifyRequest = "verify_request"
        case acceptedLogin = "accepted_login"
        case isStore = "is_store"
        case availableAdsCountUserInCurrentMonth = "available_ads_count_user_in_current_month"
        case availableAdsCountStoreInCurrentMonth = "available_ads_count_store_in_current_month"
    }
}

