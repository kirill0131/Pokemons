//
//  Pokemon.swift
//  Pokemons
//
//  Created by Kirill Orlov on 22.02.24.
//

import Foundation

import Foundation

// MARK: - PokemonsResult
struct PokemonsResult: Codable {
    let count: Int
    let next: String
    let previous: JSONNull?
    let results: [Pokemon]
}

// MARK: - Pokemon
struct Pokemon: Codable {
    let name: String
    let url: String
}
