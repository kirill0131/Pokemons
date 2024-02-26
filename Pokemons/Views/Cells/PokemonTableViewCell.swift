//
//  PokemonTableViewCell.swift
//  Pokemons
//
//  Created by Kirill Orlov on 26.02.24.
//

import UIKit

protocol PokemonCellDelegate: AnyObject {
    func didTapDetailsButton(forPokemon pokemon: Pokemon)
}

class PokemonTableViewCell: UITableViewCell {
    static let id = "PokemonTableViewCell"
    weak var delegate: PokemonCellDelegate?
    var pokemon: Pokemon?
    
    private lazy var detailsButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "arrow.right")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.textColor
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .listColor
        selectionStyle = .none
    }
    
    private func setupLayout() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailsButton)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            detailsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            detailsButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        detailsButton.addTarget(self, action: #selector(detailsButtonTapped), for: .touchUpInside)
    }
    
    func configure(with pokemon: Pokemon, delegate: PokemonCellDelegate) {
        self.pokemon = pokemon
        self.delegate = delegate
        nameLabel.text = pokemon.name.capitalized
    }
    
    @objc private func detailsButtonTapped() {
        guard let pokemon = pokemon else { return }
        delegate?.didTapDetailsButton(forPokemon: pokemon)
    }
}
