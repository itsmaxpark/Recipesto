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
    var tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    var dataSource: UITableViewDiffableDataSource<Section, Component>?
    
    let scrollView = UIScrollView()
    var headerView = UIView(frame: .zero)
    
    var width: CGFloat = ScreenSize.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureUI()
        configureVideoPlayer()
        configureTableView()
        configureDataSource()
        reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let headerView = tableView.tableHeaderView {

            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame

            //Comparison necessary to avoid infinite loop
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                tableView.tableHeaderView = headerView
            }
        }
    }
    
    func set(recipe: Item) {
        name = recipe.name
        videoUrl = recipe.videoUrl ?? ""
        ingredients = recipe.sections ?? []
        numServings = recipe.numServings ?? 1
        instructions = recipe.instructions ?? []
        
        titleLabel.text = name
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
    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.backgroundColor = .systemPink
        tableView.register(IngredientCell.self, forCellReuseIdentifier: IngredientCell.identifier)
        tableView.alwaysBounceVertical = false
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, component in
            let cell = tableView.dequeueReusableCell(withIdentifier: IngredientCell.identifier, for: indexPath) as! IngredientCell
            cell.set(component: component)
            return cell
        })
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        addChild(videoPlayer)
    }
    
    private func configureUI() {
        let padding: CGFloat = 6
        let width: CGFloat = ScreenSize.width
        view.addSubview(tableView)
//        headerView.addSubviews(titleLabel, videoPlayer.view)
//        tableView.tableHeaderView = headerView
//        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
//            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
//            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
//            titleLabel.heightAnchor.constraint(equalToConstant: 80),
//
//            videoPlayer.view.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
//            videoPlayer.view.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
//            videoPlayer.view.widthAnchor.constraint(equalToConstant: width),
//            videoPlayer.view.heightAnchor.constraint(equalToConstant: width),

        ])
    }
}

extension RecipeInfoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80+width
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let headerView = UIView()
        headerView.addSubviews(titleLabel, videoPlayer.view)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 80),

            videoPlayer.view.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            videoPlayer.view.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            videoPlayer.view.widthAnchor.constraint(equalTo: headerView.widthAnchor),
            videoPlayer.view.heightAnchor.constraint(equalTo: headerView.heightAnchor),
        ])
        return headerView
    }
    
}
