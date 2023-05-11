//
//  ViewController.swift
//  cobaTableView
//
//  Created by Goldy Pasulu on 19/10/22.
//

import UIKit
import Foundation

class ViewController2: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    var arrCoins : [DataCoin] = []
    
    var arrName : [String] = []
    var arrPrice : [String] = []
    var arrSymbol : [String] = []
    var arrChange : [String] = []
    var arrImage : [URL] = []
    
    var arrFavoriteIndex : [Int] = []
    let userDefaults = UserDefaults.standard
    
    var data = ["Bacon", "Egg", "Cereal", "Milk", "Tomato", "Oatmeal", "Orange Juice"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        let arr = self.userDefaults.array(forKey: "theScore") as? [Int] ?? [Int]()
        
        for i in arr {
            arrFavoriteIndex.append(i)
        }
        
        // API
        let headers = [
            "X-RapidAPI-Key": "8213c5117dmsh7e181da45da6692p1844c3jsn5cc229a32370",
            "X-RapidAPI-Host": "coinranking1.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://coinranking1.p.rapidapi.com/coins?referenceCurrencyUuid=yhjMzLPhuIDl&timePeriod=24h&tiers%5B0%5D=1&orderBy=marketCap&orderDirection=desc&limit=50&offset=0")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [self] (data, response, error) -> Void in
            if (error != nil) {
            } else {
                let httpResponse = response as? HTTPURLResponse
            }

            if let iniData = data {
                
                let dataString = String(data: iniData, encoding: .utf8)
                
                let jsonData = dataString!.data(using: .utf8)!
                let dataCoin: Fetch = try! JSONDecoder().decode(Fetch.self, from: jsonData)
                
                for i in 0...49{
                    for j in arrFavoriteIndex{
                        if (i == j){
                            self.arrCoins.append(dataCoin.data.coins[i])
                        }
                    }
                }
                
                print(arrCoins)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
        
        dataTask.resume()
        
    }
    
    // TABLE VIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2")! as! CustomTableViewCell1
        //cell.accessoryType = .disclosureIndicator
       
        var url = arrCoins[indexPath.row].iconUrl
        
        DispatchQueue.global().async {
            let data = try? Data (contentsOf: url)
            DispatchQueue.main.async {
                cell.imageViewLogo.image = UIImage(data: data!)
            }
        }
        
        //cell.imageViewLogo.image = UIImage(named: "down")
        cell.labelSymbol?.text = arrCoins[indexPath.row].symbol
        cell.labelPrice?.text = arrCoins[indexPath.row].price
        cell.labelName?.text = arrCoins[indexPath.row].name
        
        if ((arrCoins[indexPath.row].change as NSString).floatValue < 0){
            cell.imageViewChange.image = UIImage(systemName: "chevron.down.circle")
            
            cell.imageViewChange.tintColor = UIColor.red
            cell.labelChange?.text = arrCoins[indexPath.row].change
            cell.labelChange?.textColor = UIColor.red
            
        } else {
            
            cell.imageViewChange.image = UIImage(systemName: "chevron.up.circle")
            cell.imageViewChange.tintColor = UIColor.green
            cell.labelChange?.text = arrCoins[indexPath.row].change
            cell.labelChange?.textColor = UIColor.green
            
        }
        
        cell.favoriteFunc = {[unowned self] in
            
            let outletfavorite = UIImage(systemName: "hand.thumbsup")
            cell.outletFavorite.setImage(outletfavorite, for: .normal)
            
            arrFavoriteIndex.remove(at: indexPath.row)
            userDefaults.set(arrFavoriteIndex, forKey: "theScore")
            print(arrFavoriteIndex)
        }
        
        return cell
        
    }
}
