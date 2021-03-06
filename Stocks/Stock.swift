//
//  Stock.swift
//  Stocks
//
//  Created by Максим on 06.03.2021.
//

import Foundation
struct Stock: Decodable{ //Структура компании
    var name: String
    var symbol: String
    var has_intraday: Bool
    var has_eod: Bool
    var country: String?
    struct stock_exchange {
        var name: String
        var acronym: String
        var mic: String
        var country: String
        var country_code: String
        var city: String
        var website: String
    }
}
struct Pagination: Decodable{ //С этой структуры начинается каждый ответ сервера, зачем он я не знаю, но пусть будет
    var limit: Int
    var offset: Int
    var count: Int
    var total: Int
}
struct StocksLoad: Decodable{ //Структура списка компаний
    var pagination: Pagination
    var data: [Stock]
    
}
struct oneStockData: Decodable { //Структура акций компании
    var open: Float
    var high: Float
    var low: Float
    var close: Float
    var volume: Int
    var adj_high: Float
    var adj_low: Float
    var adj_close: Float
    var adj_open: Float
    var adj_volume: Int
    var symbol: String
    var exchange: String
    var date: String
}
struct StockLoadData: Decodable{ //Структура акций компании
    var pagination: Pagination
    var data: [oneStockData]
}
struct StocksLoadedData {
    var company: StocksLoad
    var stock: oneStockData
}
