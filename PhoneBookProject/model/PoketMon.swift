//
//  PoketMon.swift
//  PhoneBookProject
//
//  Created by 박승환 on 7/15/24.
//

import Foundation

struct PoketMon: Codable {
    let sprites: Sprite
}

struct Sprite: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
