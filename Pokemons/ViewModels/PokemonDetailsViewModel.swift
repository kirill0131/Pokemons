//
//  PokemonDetailsViewModel.swift
//  Pokemons
//
//  Created by Kirill Orlov on 22.02.24.
//

import Combine
import UIKit

class PokemonDetailsViewModel {
    let pokemon: Pokemon
    @Published var pokemonDetail: PokemonDetails?
    @Published var spriteImages: [UIImage] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var pokemonService: PokemonService
    private var cancellables: Set<AnyCancellable> = []
    
    init(pokemon: Pokemon, pokemonService: PokemonService) {
        self.pokemon = pokemon
        self.pokemonService = pokemonService
    }
    
    func fetchPokemonDetails() {
        isLoading = true
        
        if let cachedDetails = FakeCashService.shared.checkDetails(for: pokemon),
           let cachedImages = FakeCashService.shared.checkImages(for: cachedDetails) {
            self.pokemonDetail = cachedDetails
            self.spriteImages = cachedImages
            self.isLoading = false
        } else {
            pokemonService.fetchPokemonDetail(pokemon: pokemon)
                .flatMap { [weak self] details -> AnyPublisher<[UIImage], Error> in
                    FakeCashService.shared.addDetails(details)
                    self?.pokemonDetail = details
                    
                    if let cachedImages = FakeCashService.shared.checkImages(for: details) {
                        return Just(cachedImages).setFailureType(to: Error.self).eraseToAnyPublisher()
                    } else {
                        return self?.pokemonService.fetchSprites(from: details.sprites.allSprites) ?? Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
                    }
                }
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                }, receiveValue: { [weak self] spriteImages in
                    self?.spriteImages = spriteImages
                    FakeCashService.shared.addImages(spriteImages, pokemonName: self?.pokemon.name ?? "")
                })
                .store(in: &cancellables)
        }
    }
}
