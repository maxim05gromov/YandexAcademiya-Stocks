//
//  StocksVC.swift
//  Stocks
//
//  Created by Максим on 05.03.2021.
//
//  ViewController, отображающий список акций
import Foundation
import UIKit
class StocksViewController: UITableViewController {
    let searchController = UISearchController(searchResultsController: nil)
    var dataLoaded = false
    var showSearch = false
    var Stocks = [stocks]()
    var check = [stocks]()
    var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tableView.tableFooterView?.isHidden = true
        tableView.backgroundColor = UIColor.clear
        view.backgroundColor = .white
        super.viewDidLoad()
        let nib = UINib(nibName: "Cell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cellid")
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        showSearch = false
        let x = UIScreen.main.bounds.width / 2
        let y = UIScreen.main.bounds.height / 4
        activityIndicator.center = CGPoint(x: x, y: y)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    
    func parse(){
        activityIndicator.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
    }
    //  Функция Parse нужна для отображения данных в таблице после загрузки в MainVC. Так как данные не подгружаются моментально, сперва на этом VC отображается Activity Indicator
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataLoaded{
            if showSearch{
                return check.count
            }else{
                return Stocks.count
            }
        }else{
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Add to favourites") { _, _, complete in
            var array = self.defaults.array(forKey: "favourite")
            if(array == nil){
                array = [self.Stocks[indexPath.row].symbol!]
            }else{
                var found = false
                for i in array!{
                    if i as! String == self.Stocks[indexPath.row].symbol!{
                        found = true
                    }
                }
                if !found{
                    array?.append(self.Stocks[indexPath.row].symbol!)
                }
            }
            self.defaults.set(array, forKey: "favourite")
            array = self.defaults.array(forKey: "favourite")
            complete(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath) as! Cell
        if dataLoaded{
            if showSearch{
                cell.StockName.text = check[indexPath.row].longName
                cell.StockSymbol.text = check[indexPath.row].symbol
                cell.StockImage.image = UIImage(named: check[indexPath.row].symbol!)
                cell.StockImage.clipsToBounds = true
                cell.StockImage.contentMode = .scaleAspectFit
                cell.StockImage.layer.cornerRadius = 15
                var cost = ""
                if check[indexPath.row].financialCurrency == "USD"{
                    cost += "$"
                    cost += "\(check[indexPath.row].regularMarketPrice!)"
                }else if check[indexPath.row].financialCurrency == "RUB"{
                    cost += "\(check[indexPath.row].regularMarketPrice!)"
                    cost += " ₽"
                }else if check[indexPath.row].financialCurrency == "EUR"{
                    cost += "\(check[indexPath.row].regularMarketPrice!)"
                    cost += " €"
                }
                cell.StockCost.text = cost
                if check[indexPath.row].regularMarketChange ?? 0 >= 0{
                    cost = "+"
                    cell.StockChange.textColor = #colorLiteral(red: 0.454715784, green: 0.832876933, blue: 0.219663645, alpha: 1)
                }else{
                    cost = ""
                    cell.StockChange.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                }
                var change: Double
                change = Double(check[indexPath.row].regularMarketChange ?? 0)
                change = round(1000.0 * change) / 1000.0
                cell.StockChange.text = "\(cost)\(change)"
            }else{
                cell.StockName.text = Stocks[indexPath.row].longName
                cell.StockSymbol.text = Stocks[indexPath.row].symbol
                cell.StockImage.image = UIImage(named: Stocks[indexPath.row].symbol!)
                cell.StockImage.clipsToBounds = true
                cell.StockImage.contentMode = .scaleAspectFit
                cell.StockImage.layer.cornerRadius = 15
                var cost = ""
                if Stocks[indexPath.row].financialCurrency == "USD"{
                    cost += "$"
                    cost += "\(Stocks[indexPath.row].regularMarketPrice!)"
                }else if Stocks[indexPath.row].financialCurrency == "RUB"{
                    cost += "\(Stocks[indexPath.row].regularMarketPrice!)"
                    cost += " ₽"
                }else if Stocks[indexPath.row].financialCurrency == "EUR"{
                    cost += "\(Stocks[indexPath.row].regularMarketPrice!)"
                    cost += " €"
                }
                cell.StockCost.text = cost
                if Stocks[indexPath.row].regularMarketChange ?? 0 >= 0{
                    cost = "+"
                    cell.StockChange.textColor = #colorLiteral(red: 0.454715784, green: 0.832876933, blue: 0.219663645, alpha: 1)
                }else{
                    cost = ""
                    cell.StockChange.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                }
                var change: Double
                change = Double(Stocks[indexPath.row].regularMarketChange ?? 0)
                change = round(1000.0 * change) / 1000.0
                cell.StockChange.text = "\(cost)\(change)"
            }
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = infoVC()
        destinationVC.showStock.removeAll()
        if showSearch{
            destinationVC.showStock.append(check[indexPath.row])
        }else{
            destinationVC.showStock.append(Stocks[indexPath.row])
        }
        destinationVC.navigationItem.title = destinationVC.showStock[0].longName
        self.navigationController!.pushViewController(destinationVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    var SearchText = ""
}


extension StocksViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        showSearch = true
        check.removeAll()
        for stockCheck in Stocks{
            if stockCheck.longName?.lowercased().contains(searchText.lowercased()) ?? false || stockCheck.symbol?.lowercased().contains(searchText.lowercased()) ?? false{
                check.append(stockCheck)
            }
        }
        self.tableView.reloadData()
        SearchText = searchText
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        showSearch = false
        self.tableView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        showSearch = true
        searchController.isActive = false
        self.tableView.reloadData()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = SearchText
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = SearchText
    }
}
