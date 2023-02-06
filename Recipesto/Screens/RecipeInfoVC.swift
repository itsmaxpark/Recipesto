//
//  RecipeInfoVC.swift
//  Recipesto
//
//  Created by Max Park on 2/1/23.
//

import UIKit
import AVKit

class RecipeInfoVC: UIViewController {
    
    enum IngredientSection {
        case main
    }
    
    var name = String()
    var videoUrl = String()
    var ingredients: [Section] = []
    var numServings = 0
    var instructions: [Instruction] = []
    
    let titleLabel = RPTitleLabel(textAlignment: .center, fontSize: 32)
    let videoPlayer = AVPlayerViewController()
    var tableView: UITableView = UITableView()
    var dataSource: UITableViewDiffableDataSource<Section, Component>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureUI()
        configureVideoPlayer()
        configureTableView()
        configureDataSource()
        reloadData()
    }
    
    func set(recipe: Item) {
        name = recipe.name
        videoUrl = recipe.videoUrl ?? ""
        ingredients = recipe.sections ?? []
        numServings = recipe.numServings ?? 1
        instructions = recipe.instructions ?? []
        
        titleLabel.text = name
    }
    
    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.backgroundColor = .systemPink
        tableView.register(IngredientCell.self, forCellReuseIdentifier: IngredientCell.identifier)
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, component in
            let cell = tableView.dequeueReusableCell(withIdentifier: IngredientCell.identifier, for: indexPath) as! IngredientCell
            cell.set(component: component)
            return cell
        })
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Component>()
        snapshot.appendSections(ingredients)
        for section in ingredients {
            let components: [Component] = section.components
            snapshot.appendItems(components, toSection: section)
        }
        dataSource?.apply(snapshot)
    }
    
    private func configureVideoPlayer() {
        guard let url = URL(string: videoUrl) else { return }
        let player = AVPlayer(url: url)
        videoPlayer.player = player
        videoPlayer.showsPlaybackControls = true
        videoPlayer.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        addChild(videoPlayer)
    }
    
    private func configureUI() {
        view.addSubviews(titleLabel, videoPlayer.view, tableView)
        let padding: CGFloat = 6
        let width: CGFloat = ScreenSize.width
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 80),
            
            videoPlayer.view.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            videoPlayer.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoPlayer.view.widthAnchor.constraint(equalToConstant: width),
            videoPlayer.view.heightAnchor.constraint(equalToConstant: width),
            
            tableView.topAnchor.constraint(equalTo: videoPlayer.view.bottomAnchor, constant: padding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

extension RecipeInfoVC: UITableViewDelegate {
    
}
