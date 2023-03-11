/*
SuggestedSearchController
 
The table view controller responsible for displaying the filtered search results as the user types in the search field.
*/

import UIKit

class SuggestedSearchController: UITableViewController {
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return showSuggestedSearches ? ResultsTableController.suggestedSearches.count : filteredProducts.count
//    }
//
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return showSuggestedSearches ? NSLocalizedString("Suggested Searches", comment: "") : ""
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .value1, reuseIdentifier: UITableViewController.productCellIdentifier)
//
//        if showSuggestedSearches {
//            let suggestedtitle = NSMutableAttributedString(string: ResultsTableController.suggestedSearches[indexPath.row])
//            suggestedtitle.addAttribute(NSAttributedString.Key.foregroundColor,
//                                        value: UIColor.label,
//                                        range: NSRange(location: 0, length: suggestedtitle.length))
//            cell.textLabel?.attributedText = suggestedtitle
//
//            // No detailed text or accessory for suggested searches.
//            cell.detailTextLabel?.text = ""
//            cell.accessoryType = .none
//
//            // Compute the suggested image when it is the proper color.
//            let image = suggestedImage(fromIndex: indexPath.row)
//            let tintableImage = image.withRenderingMode(.alwaysOriginal)
//            cell.imageView?.image = tintableImage
//        } else {
//            let product = filteredProducts[indexPath.row]
//            configureCell(cell, forProduct: product)
//        }
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // We must have a delegate to respond to row selection.
//        guard let suggestedSearchDelegate = suggestedSearchDelegate else { return }
//
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        // Make sure we are showing suggested searches before notifying which token was selected.
//        if showSuggestedSearches {
//            // A suggested search was selected; inform our delegate that the selected search token was selected.
//            let tokenToInsert = ResultsTableController.searchToken(tokenValue: indexPath.row)
//            suggestedSearchDelegate.didSelectSuggestedSearch(token: tokenToInsert)
//        } else {
//            // A product was selected; inform our delgeate that a product was selected to view.
//            let selectedProduct = filteredProducts[indexPath.row]
//            suggestedSearchDelegate.didSelectProduct(product: selectedProduct)
//        }
//    }
}
