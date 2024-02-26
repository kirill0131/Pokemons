//
//  FakeCashService.swift
//  Pokemons
//
//  Created by Kirill Orlov on 26.02.24.
//

import UIKit

// TODO: Save cash in some db
final class FakeCashService {
    static let shared = FakeCashService()
    
    private var detailsCash: [String: PokemonDetails] = [:]
    private var imageCash: [String: [UIImage]] = [:]
    
    private init() {}
    
    func addDetails(_ details: PokemonDetails) {
        detailsCash[details.name.lowercased()] = details
    }
    
    func checkDetails(for pokemon: Pokemon) -> PokemonDetails? {
        return detailsCash[pokemon.name.lowercased()]
    }
    
    func addImages(_ images: [UIImage], pokemonName: String) {
        imageCash[pokemonName.lowercased()] = images
    }
    
    func checkImages(for pokemon: PokemonDetails) -> [UIImage]? {
        return imageCash[pokemon.name.lowercased()]
    }
}
