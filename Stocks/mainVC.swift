//
//  mainVC.swift
//  Stocks
//
//  Created by Максим on 05.03.2021.
//

import UIKit
class mainViewController: UITabBarController{
    override func viewDidLoad() {
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
        tabBar.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        viewControllers = [
            stocksVC,
            favouritesVC
        ]
    }
}
