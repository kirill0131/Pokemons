//
//  PokemonStatsView.swift
//  Pokemons
//
//  Created by Kirill Orlov on 26.02.24.
//

import UIKit

class PokemonStatsView: UIView {
    // MARK: - UI Elements
    private let statsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(statsStackView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            statsStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            statsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            statsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    func configure(with stats: [Stat]) {
        statsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for stat in stats {
            let statLabel = UILabel()
            statLabel.font = UIFont.systemFont(ofSize: 16)
            statLabel.textColor = .black
            statLabel.textAlignment = .left
            statLabel.text = "\(stat.stat.name.capitalized): \(stat.baseStat)"
            statsStackView.addArrangedSubview(statLabel)
        }
    }
}
