//
//  PokemonService.swift
//  Pokemons
//
//  Created by Kirill Orlov on 22.02.24.
//

import Combine
import UIKit

class PokemonService {
    public let baseURL = Constants.Strings.baseUrl

    func fetchPokemonList(from url: URL) -> AnyPublisher<PokemonListResponse, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PokemonListResponse.self, decoder: JSONDecoder())
            .map { $0 }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchPokemonDetail(pokemon: Pokemon) -> AnyPublisher<PokemonDetails, Error> {
        let url = URL(string: "\(pokemon.url)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PokemonDetails.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchSprites(from spriteUrls: [String]) -> AnyPublisher<[UIImage], Error> {
        let spritePublishers = spriteUrls.compactMap { URL(string: $0) }.map { url in
            URLSession.shared.dataTaskPublisher(for: url)
                .mapError { $0 as Error }
                .map { UIImage(data: $0.data) }
                .compactMap { $0 }
                .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(spritePublishers).collect().eraseToAnyPublisher()
    }
}


