//
//  Stock.swift
//  Stocks
//
//  Created by Максим on Float.2021.
//

import Foundation

struct stocks: Decodable{
    var ask: Float?
    var askSize: Int?
    var averageDailyVolume10Day: Int?
    var averageDailyVolume3Month: Int?
    var bid: Float?
    var bidSize: Int?
    var bookValue: Float?
    var currency: String?
    struct dividendDate{
        var date: String?
        var timezone_type: Int?
        var timezone: String?
    }
    struct earningsTimestamp{
        var date: String?
        var timezone_type: Int?
        var timezone: String?
    }
    struct earningsTimestampStart{
        var date: String?
        var timezone_type: Int?
        var timezone: String?
    }
    struct earningsTimestampEnd{
        var date: String?
        var timezone_type: Int?
        var timezone: String?
    }
    var epsForward: Float?
    var epsTrailingTwelveMonths: Float?
    var exchange: String?
    var exchangeDataDelayedBy: Int?
    var exchangeTimezoneName: String?
    var exchangeTimezoneShortName: String?
    var fiftyDayAverage: Float?
    var fiftyDayAverageChange: Float?
    var fiftyDayAverageChangePercent: Float?
    var fiftyTwoWeekHigh: Float?
    var fiftyTwoWeekHighChange: Float?
    var fiftyTwoWeekHighChangePercent: Float?
    var fiftyTwoWeekLow: Float?
    var fiftyTwoWeekLowChange: Float?
    var fiftyTwoWeekLowChangePercent: Float?
    var financialCurrency: String?
    var forwardPE: Float?
    var fullExchangeName: String?
    var gmtOffSetMilliseconds: Int?
    var language: String?
    var longName: String?
    var market: String?
    var marketCap: Int?
    var marketState: String?
    var messageBoardId: String?
    var postMarketChange: Float?
    var postMarketChangePercent: Float?
    var postMarketPrice: Float?
    struct postMarketTime{
        var date: String?
        var timezone_type: Int?
        var timezone: String?
    }
    var priceHint: Int?
    var priceToBook: Float?
    var quoteSourceName: String?
    var quoteType: String?
    var regularMarketChange: Float?
    var regularMarketChangePercent: Float?
    var regularMarketDayHigh: Float?
    var regularMarketDayLow: Float?
    var regularMarketOpen: Float?
    var regularMarketPreviousClose: Float?
    var regularMarketPrice: Float?
    struct regularMarketTime{
        var date: String?
        var timezone_type: Int?
        var timezone: String?
    }
    var regularMarketVolume: Int?
    var sharesOutstanding: Int?
    var shortName: String?
    var sourceInterval: Int?
    var symbol: String?
    var tradeable: Bool?
    var trailingAnnualDividendRate: Float?
    var trailingAnnualDividendYield: Float?
    var trailingPE: Float?
    var twoHundredDayAverage: Float?
    var twoHundredDayAverageChange: Float?
    var twoHundredDayAverageChangePercent: Float?
}
