//
//  InfoVC.swift
//  Stocks
//
//  Created by Максим on 06.03.2021.
//

import UIKit
import SafariServices
class infoVC: UITableViewController{
    var showStock = [stocks]()
    var showNews = [newsModel]()
    var newsLoaded = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "InfoCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cellid1")
        view.backgroundColor = .white
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tableView.tableFooterView?.isHidden = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let url = URL(string: "https://mboum.com/api/v1/ne/news/?symbol=\(showStock[0].symbol!)&apikey=pP6wJSVkgnyK89qvY6RDnrb1NCc0vOL3p1wZjs226KeBAomLDLdYsHoW4UH9")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else{ return }
            do{
                let loadNews = try JSONDecoder().decode(news.self, from: data)
                self.showNews = []
                self.showNews.append(loadNews.item[0])
                self.showNews.append(loadNews.item[1])
                self.showNews.append(loadNews.item[2])
                self.newsLoaded = true
            }catch let error{
                print(error)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.resume()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
        return 8
        }else{
            return 3
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid1", for: indexPath) as! infoCell
        if indexPath.section == 0{
        switch (indexPath.row){
        case 0:
            cell.Name.text = "Open"
            if showStock[0].regularMarketOpen != nil{
                cell.Data.text = "\(showStock[0].regularMarketOpen!)"
            }else{
                cell.Data.text = "N/A"
            }
            break
        case 1:
            cell.Name.text = "High"
            if showStock[0].regularMarketDayHigh != nil{
                cell.Data.text = "\(showStock[0].regularMarketDayHigh!)"
            }else{
                cell.Data.text = "N/A"
            }
            break
        case 2:
            cell.Name.text = "Low"
            if showStock[0].regularMarketDayLow != nil{
                cell.Data.text = "\(showStock[0].regularMarketDayLow!)"
            }else{
                cell.Data.text = "N/A"
            }
            break
        case 3:
            cell.Name.text = "Vol"
            if showStock[0].regularMarketVolume != nil{
                let vol = showStock[0].regularMarketVolume
                var text = ""
                if vol! > 1000000{
                    text = "\(vol! / 1000000)M"
                }else{
                    if vol! > 1000{
                        text = "\(vol! / 1000)K"
                    }else{
                        text = "\(vol!)"
                    }
                }
                cell.Data.text = text
            }else{
                cell.Data.text = "N/A"
            }
            break
        case 4:
            cell.Name.text = "P/E"
            if showStock[0].trailingPE != nil{
                var change = Double(showStock[0].trailingPE!)
                change = round(1000.0 * change) / 1000.0
                cell.Data.text = "\(change)"
            }else{
                cell.Data.text = "N/A"
            }
            break
        case 5:
            cell.Name.text = "Market Cap"
            if showStock[0].marketCap != nil{
                var text = ""
                let cap = showStock[0].marketCap
                if cap! > 1000000000000{
                    text = "\(cap! / 1000000000000)T"
                }else{
                    if cap! > 1000000000{
                        text = "\(cap! / 1000000000)B"
                    }else{
                        if cap! > 1000000{
                            text = "\(cap! / 1000000)M"
                        }else{
                            text = "\(String(describing: cap))"
                        }
                    }
                }
                cell.Data.text = text
            }else{
                cell.Data.text = "N/A"
            }
            break
        case 6:
            cell.Name.text = "52W H"
            if showStock[0].fiftyTwoWeekHigh != nil{
                cell.Data.text = "\(showStock[0].fiftyTwoWeekHigh!)"
            }else{
                cell.Data.text = "N/A"
            }
            break
        case 7:
            cell.Name.text = "52W L"
            if showStock[0].fiftyTwoWeekLow != nil{
                cell.Data.text = "\(showStock[0].fiftyTwoWeekLow!)"
            }else{
                cell.Data.text = "N/A"
            }
            break
        default:
            print("error!")
            break
        }
        }else if indexPath.section == 1{
            if !newsLoaded{
                cell.Name.text = "Loading news..."
                cell.Data.text = ""
            }else{
                cell.Name.text = showNews[indexPath.row].title
                cell.Data.text = ""
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        if section == 0{
            return "Statistics"
        }else if section == 1{
            return "News"
        }else{
            return ""
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 && newsLoaded{
            let svc = SFSafariViewController(url: URL(string: showNews[indexPath.row].link)!)
            present(svc, animated: true, completion: nil)
        }
    }
}

