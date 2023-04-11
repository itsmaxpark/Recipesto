//
//  MultipleRecipeInfoVC.swift
//  Recipesto
//
//  Created by Max Park on 3/13/23.
//

import UIKit
import AVKit

class MultipleRecipeInfoVC: UIViewController {
    
    struct MultipleRecipeSection: Hashable {
        let recipes: [Recipe]?
        let title: String?
    }
    
    var section: MultipleRecipeSection!
    
    var name = String()
    var videoUrl = String()
    var recipes: [Recipe] = []
    
    let titleLabel = RPTitleLabel(textAlignment: .left, fontSize: 28)
    let videoPlayer = AVPlayerViewController()
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<MultipleRecipeSection, Item>?
    
    var headerView = UIView(frame: .zero)
    
    var width: CGFloat = ScreenSize.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureNavigationBar()
        configureCV()
        configureVideoPlayer()
        configureDataSource()
        reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    func set(item: Item) {
        name = item.name
        videoUrl = item.videoUrl ?? ""
        recipes = item.recipes ?? []
        titleLabel.text = name
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<MultipleRecipeSection, Item>()
        var sections: [MultipleRecipeSection] = []
        section = MultipleRecipeSection(recipes: recipes, title: name)
        sections.append(section)
        snapshot.appendSections(sections)
        
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func addToFavorites() {
        #warning("TODO: persistance manager")
    }
    
    private func configureVideoPlayer() {
        guard let url = URL(string: videoUrl) else { return }
        let player = AVPlayer(url: url)
        videoPlayer.player = player
        videoPlayer.showsPlaybackControls = true
        videoPlayer.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureCV() {
        collectionView = UICollectionView(frame: view.safeAreaLayoutGuide.layoutFrame, collectionViewLayout: createCompositionalLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.automaticallyAdjustsScrollIndicatorInsets = true
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        collectionView.contentInset = adjustForTabbarInsets
        collectionView.scrollIndicatorInsets = adjustForTabbarInsets
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.identifier)
        collectionView.register(RPSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RPSectionHeader.reuseIdentifier)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self else { fatalError() }
            
            return self.createRecipesSection(using: self.section)
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        config.scrollDirection = .vertical
        layout.configuration = config
        return layout
    }
    
    private func createRecipesSection(using: MultipleRecipeSection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.28))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, repeatingSubitem: layoutItem, count: 2)

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    private func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, recipe in
            if let recipe = recipe as? Item {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.identifier, for: indexPath) as! RecipeCell
                cell.set(recipe: recipe)
                return cell
            } else {
                fatalError("Unknown Item Identifier")
            }
        })
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        let button = RPImageButton(color: .systemGreen, image: SFSymbols.heart)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        let saveButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        addChild(videoPlayer)
    }
    
    @objc private func saveButtonTapped() {
        addToFavorites()
    }
}

extension MultipleRecipeInfoVC: UICollectionViewDelegate {
    
}

