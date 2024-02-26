//
//  PokemonListResponse.swift
//  Pokemons
//
//  Created by Kirill Orlov on 26.02.24.
//

import Foundation

struct PokemonListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}
