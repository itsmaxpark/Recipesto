//
//  RecipeInfoVC.swift
//  Recipesto
//
//  Created by Max Park on 2/1/23.
//

import UIKit
import AVKit

class RecipeInfoVC: NiblessViewController {
    
    // MARK: - Properties
    let viewModel: RecipeInfoViewModel
    var rootView: RecipeInfoRootView {
        view as! RecipeInfoRootView
    }

    // MARK: - Methods
    init(viewModel: RecipeInfoViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        super.loadView()
        view = RecipeInfoRootView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: ScreenSize.width,
                height: ScreenSize.height),
            viewModel: viewModel
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let headerView = rootView.tableView.tableHeaderView {

            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame

            //Comparison necessary to avoid infinite loop
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                rootView.tableView.tableHeaderView = headerView
            }
        }
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        addChild(rootView.videoPlayer)
        rootView.videoPlayer.didMove(toParent: self)
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        let button = RPImageButton(color: .systemGreen, image: SFSymbols.heart)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        let saveButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc private func saveButtonTapped() {
        rootView.addToFavorites()
    }
}


