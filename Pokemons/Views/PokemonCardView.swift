//
//  PokemonCardView.swift
//  Pokemons
//
//  Created by Kirill Orlov on 22.02.24.
//

import UIKit

protocol PokemonCardViewDelegate: AnyObject {
    func showSaveImageAlert(with image: UIImage)
}

class PokemonCardView: UIView {
    // MARK: - UI Elements
    private let imageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 70
        view.layer.masksToBounds = true
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let spritesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: 140, height: 140)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pokemonStats: PokemonStatsView = {
        let view = PokemonStatsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // - MARK: Properties
    weak var cardDelegate: PokemonCardViewDelegate?
    private var spriteImages: [UIImage] = []
    
    // - MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(imageBackgroundView)
        
        spritesCollectionView.register(SpriteCollectionViewCell.self, forCellWithReuseIdentifier: SpriteCollectionViewCell.id)
        spritesCollectionView.dataSource = self
        spritesCollectionView.delegate = self
        imageBackgroundView.addSubview(spritesCollectionView)
        
        addSubview(nameLabel)
        
        addSubview(typeLabel)
        
        addSubview(pokemonStats)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            imageBackgroundView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            imageBackgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageBackgroundView.widthAnchor.constraint(equalToConstant: 140),
            imageBackgroundView.heightAnchor.constraint(equalToConstant: 140),
            
            spritesCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            spritesCollectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            spritesCollectionView.widthAnchor.constraint(equalToConstant: 140),
            spritesCollectionView.heightAnchor.constraint(equalToConstant: 140),
            
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageBackgroundView.bottomAnchor, constant: 20),
            
            typeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            
            pokemonStats.centerXAnchor.constraint(equalTo: centerXAnchor),
            pokemonStats.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 10),
            pokemonStats.widthAnchor.constraint(equalToConstant: 200),
            pokemonStats.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // MARK: - Configuring methods
    func configure(with details: PokemonDetails) {
        nameLabel.text = details.name.capitalized
        typeLabel.text = "Type: \(details.types.map { $0.type.name.capitalized }.joined(separator: ", "))"
        
        pokemonStats.configure(with: details.stats)
    }
    
    func updateSprites(with images: [UIImage]) {
        spriteImages = images
        spritesCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension PokemonCardView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spriteImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpriteCollectionViewCell.id, for: indexPath) as? SpriteCollectionViewCell else {
            fatalError("Unable to dequeue SpriteCollectionViewCell")
        }
        cell.configure(with: spriteImages[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PokemonCardView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = spriteImages[indexPath.item]
        cardDelegate?.showSaveImageAlert(with: selectedImage)
    }
}
