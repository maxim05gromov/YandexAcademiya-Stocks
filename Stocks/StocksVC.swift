//
//  StocksVC.swift
//  Stocks
//
//  Created by Максим on 05.03.2021.
//
import Foundation
import UIKit
class StocksViewController: UITableViewController {
    let searchController = UISearchController(searchResultsController: nil)
    var dataLoaded = false //Когда true, в tableView подгружаются данные из переменных
    var showSearch = false //Когда True, в tableView подгружаются данные поиска
    private var Stocks = [stocks]()
    private var check = [stocks]()
    override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tableView.tableFooterView?.isHidden = true
        tableView.backgroundColor = UIColor.clear
        view.backgroundColor = .white
        super.viewDidLoad()
        let nib = UINib(nibName: "Cell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cellid") //Создаем объект Cell
        setupSearchBar()   //Инициализируем строку поиска
        dataLoaded = false
        showSearch = false
        let x = UIScreen.main.bounds.width / 2
        let y = UIScreen.main.bounds.height / 4
        activityIndicator.center = CGPoint(x: x, y: y)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        loadData()
    }
    var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    
    func loadData(){
    let url = URL(string: "http://www.mboum.com/api/v1/qu/quote/?symbol=YNDX,AAPL,MSFT,AMZN,GOOG,FB,VOD,INTC,PEP,ADBE,CSCO,NVDA,NFLX,TSLA,PYPLAVGO,SBUX,QCOM,TMUS,BKNG,AMD,ADSK,EA,EBAY&apikey=pP6wJSVkgnyK89qvY6RDnrb1NCc0vOL3p1wZjs226KeBAomLDLdYsHoW4UH9")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else{ return }
            do{
                //print(String(decoding: data, as: UTF8.self))
                self.Stocks = try JSONDecoder().decode([stocks].self, from: data)
            }catch let error{
                print(error)
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.dataLoaded = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }.resume()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    private func setupSearchBar(){
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
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
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath) as! Cell
        if dataLoaded{
            if showSearch{
                cell.StockName.text = check[indexPath.row].longName
                cell.StockSymbol.text = check[indexPath.row].symbol
            }else{
                cell.StockName.text = Stocks[indexPath.row].longName
                cell.StockSymbol.text = Stocks[indexPath.row].symbol
                var cost = ""
                if Stocks[indexPath.row].financialCurrency == "USD"{
                    cost += "$"
                    cost += "\(Stocks[indexPath.row].regularMarketPrice)"
                }else if Stocks[indexPath.row].financialCurrency == "RUB"{
                    cost += "\(Stocks[indexPath.row].regularMarketPrice)"
                    cost += " ₽"
                }else if Stocks[indexPath.row].financialCurrency == "EUR"{
                    cost += "\(Stocks[indexPath.row].regularMarketPrice)"
                    cost += " €"
                }
                cell.StockCost.text = cost
                if Stocks[indexPath.row].regularMarketChange >= 0{
                    cost = "+"
                    cell.StockChange.textColor = #colorLiteral(red: 0.454715784, green: 0.832876933, blue: 0.219663645, alpha: 1)
                }else{
                    cost = ""
                    cell.StockChange.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                }
                var change: Double
                change = Double(Stocks[indexPath.row].regularMarketChange)
                change = round(1000.0 * change) / 1000.0
                cell.StockChange.text = "\(cost)\(change)"
                
            }
        }
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    var SearchText = ""
}
extension StocksViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        showSearch = true
        check.removeAll()
        for stockCheck in Stocks{
            if stockCheck.longName.lowercased().contains(searchText.lowercased()) || stockCheck.symbol.lowercased().contains(searchText.lowercased()){
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
