//
//  StocksVC.swift
//  Stocks
//
//  Created by Максим on 05.03.2021.
//

import UIKit
class StocksViewController: UITableViewController {
    var stocksData = [StocksLoad]() //Названия и некоторые данные о компании
    
    let searchController = UISearchController(searchResultsController: nil)
    var dataLoaded = false //Когда true, в tableView подгружаются данные из переменных
    var showSearch = false //Когда True, в tableView подгружаются данные поиска
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "Cell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cellid") //Создаем объект Cell
        setupSearchBar()   //Инициализируем строку поиска
        dataLoaded = false
        showSearch = false
        
        loadTickers() //Загружаем список компаний
        
    }
    func loadTickers() {
        guard let url = URL(string: "http://api.marketstack.com/v1/tickers?access_key=f0fd794dffda3dad1c025092dd9a36be") else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {return}
            var str = String(decoding: data, as: UTF8.self)
            str = "[\(str)]"
            let data1: Data? = str.data(using: .utf8)
            guard let data1 = data1 else {return}
            do{
                self.stocksData = try JSONDecoder().decode([StocksLoad].self, from: data1)
            } catch let error{
                print("Error:", error)
            }
            DispatchQueue.main.async {
                self.dataLoaded = true
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
                return stocksDataSearch.data.count
            }else{
        return stocksData[0].data.count
            }
        }else{
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath) as! Cell
        if dataLoaded{
            if showSearch{
                cell.StockName.text = stocksDataSearch.data[indexPath.row].name
                cell.StockSymbol.text = stocksDataSearch.data[indexPath.row].symbol
                
            }else{
                cell.StockName.text = stocksData[0].data[indexPath.row].name
                cell.StockSymbol.text = stocksData[0].data[indexPath.row].symbol
            }
        }
        return cell
        
    }
    var check = [Stock]()
    var stocksDataSearch = StocksLoad.init(pagination: Pagination.init(limit: 0, offset: 0, count: 0, total: 0), data: [Stock.init(name: "", symbol: "", has_intraday: false, has_eod: false, country: "")])
}
extension StocksViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        showSearch = true
        check.removeAll()
        for stockCheck in stocksData[0].data{
            if stockCheck.name.lowercased().contains(searchText.lowercased()) || stockCheck.symbol.lowercased().contains(searchText.lowercased()){
                check.append(stockCheck)
            }
        }
        stocksDataSearch = StocksLoad.init(pagination: stocksData[0].pagination, data: check)
        self.tableView.reloadData()
        }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        showSearch = false
        self.tableView.reloadData()
    }
}
