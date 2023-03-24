//
//  RecipeInfoRootView.swift
//  Recipesto
//
//  Created by Max Park on 3/24/23.
//

import UIKit
import Combine
import AVKit

class RecipeInfoRootView: NiblessView {
    
    let viewModel: RecipeInfoViewModel
    let input: PassthroughSubject<RecipeInfoViewModel.Input, Never> = .init()
    
    struct RecipeSection: Hashable {
        let components: [Component]?
        let instructions: [Instruction]?
        let title: String?
    }
    
    var name = String()
    var videoUrl = String()
    var ingredients: [Section] = []
    var numServings = 0
    var instructions: [Instruction] = []
    
    let titleLabel = RPTitleLabel(textAlignment: .left, fontSize: 28)
    let videoPlayer = AVPlayerViewController()
    let videoPlayerView = RPVideoPlayerView()
    var tableView = UITableView(frame: .zero, style: .grouped)
    var dataSource: UITableViewDiffableDataSource<RecipeSection, AnyHashable>?
    
    var headerView = UIView(frame: .zero)
    
    // MARK: - Methods
    init(frame: CGRect, viewModel: RecipeInfoViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        configureUI()
        configureTableView()
        configureDataSource()
        bind()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        configureVideoPlayer()
        reloadData()
    }
    
    func bind() {
        
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
        var snapshot = NSDiffableDataSourceSnapshot<RecipeSection, AnyHashable>()
        var sections: [RecipeSection] = []
        for recipeSection in ingredients {
            let section = RecipeSection(components: recipeSection.components, instructions: nil, title: recipeSection.name)
            sections.append(section)
        }
        let instructionSection = RecipeSection(components: nil, instructions: instructions, title: "Preparation")
        sections.append(instructionSection)
        
        snapshot.appendSections(sections)
        
        for section in sections {
            if let ingredients = section.components {
                snapshot.appendItems(ingredients, toSection: section)
            } else if let instructions = section.instructions {
                snapshot.appendItems(instructions, toSection: section)
            }
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func addToFavorites() {
        #warning("TODO: persistance manager")
    }
    
    private func configureVideoPlayer() {
        guard let url = URL(string: videoUrl) else { return }
        videoPlayerView.setContentUrl(url: url as NSURL)
    }
    
    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(IngredientCell.self, forCellReuseIdentifier: IngredientCell.identifier)
        tableView.register(InstructionCell.self, forCellReuseIdentifier: InstructionCell.identifier)
        tableView.alwaysBounceVertical = false
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionHeaderTopPadding = 0
        tableView.sectionFooterHeight = 0
        tableView.separatorStyle = .none
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
            if let component = item as? Component {
                let cell = tableView.dequeueReusableCell(withIdentifier: IngredientCell.identifier, for: indexPath) as! IngredientCell
                cell.set(component: component)
                return cell
            } else if let instruction = item as? Instruction {
                let cell = tableView.dequeueReusableCell(withIdentifier: InstructionCell.identifier, for: indexPath) as! InstructionCell
                cell.set(instruction: instruction)
                return cell
            } else {
                fatalError("Unknown Item Identifier")
            }
        })
    }
    
    private func configureUI() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
}

extension RecipeInfoRootView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let width: CGFloat = ScreenSize.width
        switch section {
        case 0:
            return 110 + width
        default:
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let padding: CGFloat = 16
        let sectionLabel = RPTitleLabel(textAlignment: .left, fontSize: 14)
        
        if section < ingredients.count {
            sectionLabel.text = ingredients[section].name?.uppercased() ?? "INGREDIENTS"
        } else {
            sectionLabel.text = "PREPARATION"
        }
        let headerView = UIView()
        switch section {
        case 0:
            headerView.addSubviews(
                titleLabel,
                videoPlayerView,
                sectionLabel
            )
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: padding),
                titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -padding),
                titleLabel.heightAnchor.constraint(equalToConstant: 80),
                
                videoPlayerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
                videoPlayerView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
                videoPlayerView.widthAnchor.constraint(equalTo: headerView.widthAnchor),
                videoPlayerView.heightAnchor.constraint(equalTo: headerView.widthAnchor),
                
                sectionLabel.topAnchor.constraint(equalTo: videoPlayerView.bottomAnchor, constant: 6),
                sectionLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: padding),
                sectionLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
                sectionLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
            return headerView
        default:
            headerView.addSubviews(sectionLabel)
            NSLayoutConstraint.activate([
                sectionLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 6),
                sectionLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: padding),
                sectionLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
                sectionLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
            return headerView
        }
    }
    
}
