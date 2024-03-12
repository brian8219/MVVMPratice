//
//  PokemonModel.swift
//  MVVMPratice
//
//  Created by BrianYang on 2024/3/12.
//

import Foundation

struct PokemonListResponse : Decodable {
    var count : Int?
    var next : String?
    var previos : String?
    var results : [PokemonDic]
}


struct PokemonDic : Decodable {
    var name : String
    var url : String
}

struct PokemonDetail : Decodable {
    var base_experience : Int?
    var sprites : PokemonSprites?
}


struct PokemonSprites : Decodable {
    var front_default : String?
}

