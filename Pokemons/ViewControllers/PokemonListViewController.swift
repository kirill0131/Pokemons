//
//  PokemonListViewController.swift
//  Pokemons
//
//  Created by Kirill Orlov on 22.02.24.
//

import UIKit
import Combine

class PokemonListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var viewModel: PokemonListViewModel!
    private var cancellables = Set<AnyCancellable>()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Pokemon List"
        setupTableView()
        bindViewModel()
        viewModel.fetchMorePokemons()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .listSecondColor
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: PokemonTableViewCell.id)
    }
    
    private func bindViewModel() {
        viewModel.$pokemons
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let scrollViewHeight = scrollView.frame.size.height
        let contentHeight = scrollView.contentSize.height
        
        let fetchThreshold = contentHeight - scrollViewHeight - (tableView.rowHeight * 5)
        
        if position > fetchThreshold && !viewModel.isLoading {
            viewModel.fetchMorePokemons()
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonTableViewCell.id, for: indexPath) as? PokemonTableViewCell else {
            fatalError("Unable to dequeue PokemonTableViewCell")
        }
        let pokemon = viewModel.pokemons[indexPath.row]
        cell.configure(with: pokemon, delegate: self)
        return cell
    }
}

// MARK: - PokemonCellDelegate
extension PokemonListViewController: PokemonCellDelegate {
    func didTapDetailsButton(forPokemon pokemon: Pokemon) {
        let detailsViewModel = PokemonDetailsViewModel(pokemon: pokemon, pokemonService: PokemonService())
        let detailsViewController = PokemonDetailsViewController()
        detailsViewController.viewModel = detailsViewModel
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
