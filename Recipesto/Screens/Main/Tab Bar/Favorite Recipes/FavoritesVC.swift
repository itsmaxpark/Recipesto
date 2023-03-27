//
//  FavoritesVC.swift
//  Recipesto
//
//  Created by Max Park on 11/20/22.
//

import UIKit
import Combine

class FavoritesVC: NiblessViewController {
    
    let viewModel: FavoritesViewModel
    let input: PassthroughSubject<FavoritesViewModel.Input, Never> = .init()
    var cancellables: Set<AnyCancellable> = .init()
    
    let tableView = UITableView()
    
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init()
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.send(.viewDidAppear)
    }
    
    func bind() {
        
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchFavoriteRecipesDidSucceed(let recipes):
                    self?.updateUI(with: recipes)
                case .fetchRecipesDidFail(let error):
                    print("Error fetching browse recipes: \(error)")
                }
            }.store(in: &cancellables)
    }
    
    func configureVC() {
        view.backgroundColor = .secondarySystemBackground
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExcessCells()
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.identifier)
    }
    
    func updateUI(with favorites: [Item]) {
        if favorites.isEmpty {
            print("updateUI: No favorites saved")
        } else {
            viewModel.favorites = favorites
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
}

extension FavoritesVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identifier) as! FavoriteCell
        let favorite = viewModel.favorites[indexPath.row]
        cell.set(favorite: favorite)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = viewModel.favorites[indexPath.row]
        viewModel.coordinator.goToRecipeInfoVC(with: favorite)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        let itemToDelete = viewModel.favorites[indexPath.row]
        PersistenceManager.updateWith(favorite: itemToDelete, actionType: .remove)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    // Update the table view after deleting the favorite
                    self?.viewModel.favorites.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                case .failure(let error):
                    // Handle the error if the favorite could not be deleted
                    print("Error deleting favorite: \(error)")
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
}

