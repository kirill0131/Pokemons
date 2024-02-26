//
//  PokemonDetailsViewController.swift
//  Pokemons
//
//  Created by Kirill Orlov on 22.02.24.
//

import UIKit
import Combine

class PokemonDetailsViewController: UIViewController {
    var viewModel: PokemonDetailsViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    private let pokemonCardView = PokemonCardView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Pokemon Details"
        view.backgroundColor = .detailsColor
        setupLayout()
        bindViewModel()
        viewModel.fetchPokemonDetails()
    }
    
    private func setupLayout() {
        pokemonCardView.translatesAutoresizingMaskIntoConstraints = false
        pokemonCardView.cardDelegate = self
        
        view.addSubview(pokemonCardView)
        
        NSLayoutConstraint.activate([
            pokemonCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pokemonCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pokemonCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pokemonCardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$pokemonDetail
            .receive(on: RunLoop.main)
            .sink { [weak self] details in
                self?.updateUI(with: details)
            }
            .store(in: &cancellables)
        
        viewModel.$spriteImages
            .receive(on: RunLoop.main)
            .sink { [weak self] spriteImages in
                self?.pokemonCardView.updateSprites(with: spriteImages)
            }
            .store(in: &cancellables)
    }
    
    private func updateUI(with details: PokemonDetails?) {
        guard let pokemonDetails = details else { return }
        pokemonCardView.configure(with: pokemonDetails)
    }
}

extension PokemonDetailsViewController: PokemonCardViewDelegate {
    func showSaveImageAlert(with image: UIImage) {
        let alertController = UIAlertController(title: "Sure?", message: "Do you want to save a picture of a Pokemon?", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}
