//
//  mainVC.swift
//  Stocks
//
//  Created by Максим on 05.03.2021.
//
//  Этот файл нужен для создания TabBar, Stocks View Controller и Faforites View Controller. Также в этом файле происходит загрузка данных из API.
import UIKit
var apiKey = "6c00CHQNdNIhqbUXxNUjLvAy2wJohWgihQmm2KYumhOOcDnp3jFLNcIcVO2W"
class mainViewController: UITabBarController{
    override func viewDidLoad() {
        let defaults = UserDefaults.standard
        super.viewDidLoad()
        
        let stocksVC1 = StocksViewController()
        let stocksVC = UINavigationController(rootViewController: stocksVC1)
        stocksVC.tabBarItem.image = #imageLiteral(resourceName: "bar_chart")
        stocksVC.tabBarItem.title = "Stocks"
        stocksVC1.navigationItem.title = "Stocks"
        stocksVC.navigationBar.prefersLargeTitles = true
        

        let favouritesVC1 = FavouritesViewController()
        let favouritesVC = UINavigationController(rootViewController: favouritesVC1)
        favouritesVC.tabBarItem.image = #imageLiteral(resourceName: "star")
        favouritesVC.tabBarItem.title = "Favourites"
        favouritesVC1.navigationItem.title = "Favourites"
        favouritesVC.navigationBar.prefersLargeTitles = true
        
        
        let url = URL(string: "http://www.mboum.com/api/v1/qu/quote/?symbol=YNDX,AAPL,MSFT,AMZN,GOOG,FB,VOD,INTC,PEP,ADBE,CSCO,NVDA,NFLX,TSLA,SBUX,QCOM,TMUS,BKNG,AMD,ADSK,EA,EBAY&apikey=\(apiKey)")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else{ return }
            do{
                stocksVC1.Stocks = try JSONDecoder().decode([stocks].self, from: data)
                favouritesVC1.Stocks = stocksVC1.Stocks
            }catch let error{
                print(error)
            }
            DispatchQueue.main.async {
                stocksVC1.dataLoaded = true
                stocksVC1.parse()
                favouritesVC1.dataLoaded = true
                favouritesVC1.getData()
                let symbols = defaults.array(forKey: "favourite")
                for i in symbols!{
                    for j in favouritesVC1.Stocks{
                        if j.symbol == i as? String{
                            favouritesVC1.StocksShow.append(j)
                            break
                        }
                    }
                }
            }
        }.resume()
        
        
        tabBar.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        viewControllers = [
            stocksVC,
            favouritesVC
        ]
    }
}
