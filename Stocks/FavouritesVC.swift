//
//  FavouritesVC.swift
//  Stocks
//
//  Created by Максим on 05.03.2021.
//

import UIKit
class FavouritesViewController: UITableViewController{
    
    
    var dataLoaded = false
    var Stocks = [stocks]()
    var StocksShow = [stocks]()
    let defaults = UserDefaults.standard
    let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
    let x = UIScreen.main.bounds.width / 2
    let y = UIScreen.main.bounds.height / 4
    var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tableView.tableFooterView?.isHidden = true
        super.viewDidLoad()
        let nib = UINib(nibName: "Cell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cellid")
        label.center = CGPoint(x: x, y: y)
        label.text = "You don't have any favourite stocks. Add them by swiping to the left"
        label.numberOfLines = 3
        label.textAlignment = .center
        let x = UIScreen.main.bounds.width / 2
        let y = UIScreen.main.bounds.height / 4
        activityIndicator.center = CGPoint(x: x, y: y)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    
    func getData(){
        let symbols = defaults.array(forKey: "favourite")
        StocksShow = []
        if symbols == nil || symbols?.count == 0{
            view.addSubview(label)
            label.isHidden = false
            activityIndicator.stopAnimating()
        }else{
            label.isHidden = true
            if self.dataLoaded{
                for i in symbols!{
                    for j in Stocks{
                        if j.symbol == i as? String{
                            StocksShow.append(j)
                            break
                        }
                    }
                }
                tableView.reloadData()
                activityIndicator.stopAnimating()
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let stock = StocksShow[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
            var array = self.defaults.array(forKey: "favourite")
            array = array!.filter { $0 as? String != stock.symbol }
            self.defaults.set(array, forKey: "favourite")
            self.getData()
            if array?.count == 0{
                self.tableView.reloadData()
                self.label.isHidden = false
            }
            complete(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataLoaded{
            return StocksShow.count
        }else{
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath) as! Cell
        if dataLoaded{
            cell.StockName.text = StocksShow[indexPath.row].longName
            cell.StockSymbol.text = StocksShow[indexPath.row].symbol
            cell.StockImage.image = UIImage(named: StocksShow[indexPath.row].symbol!)
            cell.StockImage.clipsToBounds = true
            cell.StockImage.contentMode = .scaleAspectFit
            cell.StockImage.layer.cornerRadius = 15
            var cost = ""
            if StocksShow[indexPath.row].financialCurrency == "USD"{
                cost += "$"
                cost += "\(StocksShow[indexPath.row].regularMarketPrice!)"
            }else if StocksShow[indexPath.row].financialCurrency == "RUB"{
                cost += "\(StocksShow[indexPath.row].regularMarketPrice!)"
                cost += " ₽"
            }else if StocksShow[indexPath.row].financialCurrency == "EUR"{
                cost += "\(StocksShow[indexPath.row].regularMarketPrice!)"
                cost += " €"
            }
            cell.StockCost.text = cost
            if StocksShow[indexPath.row].regularMarketChange ?? 0 >= 0{
                cost = "+"
                cell.StockChange.textColor = #colorLiteral(red: 0.454715784, green: 0.832876933, blue: 0.219663645, alpha: 1)
            }else{
                cost = ""
                cell.StockChange.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            }
            var change: Double
            change = Double(StocksShow[indexPath.row].regularMarketChange ?? 0)
            change = round(1000.0 * change) / 1000.0
            cell.StockChange.text = "\(cost)\(change)"
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = infoVC()
        destinationVC.showStock.removeAll()
        destinationVC.showStock.append(StocksShow[indexPath.row])
        destinationVC.navigationItem.title = destinationVC.showStock[0].longName
        self.navigationController!.pushViewController(destinationVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
