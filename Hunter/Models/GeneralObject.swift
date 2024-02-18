//
//  GeneralObject.swift
//  Bazar
//
//  Created by Amal Elgalant on 01/05/2023.
//

import Foundation

struct GeneralObject: Codable{
    var code: Int!
    var msg: String!
    var data:Int?
    var success:Bool?
    
    enum CodingKeys: String, CodingKey {
        case code = "statusCode"
        case msg = "message"
        case data = "data"
        case success = "success"
    }
    
    
}


struct ShortGeneralObject: Codable{
    var code: Int!
    var msg: String!
    var success:Bool?
    
    enum CodingKeys: String, CodingKey {
        case code = "statusCode"
        case msg = "message"
        case success = "success"
    }
    
    
}
