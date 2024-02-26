//
//  PokemonListViewModel.swift
//  Pokemons
//
//  Created by Kirill Orlov on 22.02.24.
//

import Combine
import Foundation

class PokemonListViewModel {
    @Published var pokemons: [Pokemon] = []
    
    private var nextURL: URL?
    var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    private let pokemonService: PokemonService
    
    init(pokemonService: PokemonService) {
        self.pokemonService = pokemonService
        if let url = URL(string: "\(pokemonService.baseURL)?limit=20") {
            self.nextURL = url
        }
    }
    
    func fetchMorePokemons() {
        guard !isLoading, let nextURL = self.nextURL else { return }
        isLoading = true

        pokemonService.fetchPokemonList(from: nextURL)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] response in
                self?.pokemons.append(contentsOf: response.results)
                self?.nextURL = URL(string: response.next ?? "")
            })
            .store(in: &cancellables)
    }
}
