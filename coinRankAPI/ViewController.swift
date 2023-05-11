//
//  ViewController.swift
//  cobaTableView
//
//  Created by Goldy Pasulu on 19/10/22.
//

import UIKit
import Foundation

struct Fetch: Decodable{
    
    var data: Coin
    
}

struct DataCoin: Decodable {
    
    var name: String
    var price: String
    var symbol: String
    var change: String
    var iconUrl: URL
    
}

struct Coin: Decodable {
    var coins: [DataCoin] = Array()
    
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    var arrCoins : [DataCoin] = []
    
    // NEW ARRAY UNTUK MASING MASING DATA
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
        
        if self.userDefaults.array(forKey: "theScore") != nil {

            let arr = self.userDefaults.array(forKey: "theScore") as? [Int] ?? [Int]()
            
            for i in arr {
                arrFavoriteIndex.append(i)
            }

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
                
                for i in dataCoin.data.coins{
                    self.arrCoins.append(i)
                }
                
                for i in 0...49{
                    
                    self.arrName.append(dataCoin.data.coins[i].name)
                    self.arrSymbol.append(dataCoin.data.coins[i].symbol)
                    
                    let temp = (dataCoin.data.coins[i].price as NSString).floatValue
                    let temps = (temp * 100).rounded() / 100
                    self.arrPrice.append("$" + String(temps))
                    
                    let temp2 = (dataCoin.data.coins[i].change as NSString).floatValue
                    let temps2 = (temp2 * 100).rounded() / 100
                    self.arrChange.append(String(temps2))
                    
                    self.arrImage.append(dataCoin.data.coins[i].iconUrl)
                    
                }
                
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! CustomTableViewCell1
        var url = arrImage
        DispatchQueue.global().async {
            let data = try? Data (contentsOf: url[indexPath.row])
            DispatchQueue.main.async {
                cell.imageViewLogo.image = UIImage(data: data!)
                
            }
        }
        
        cell.labelSymbol?.text = arrSymbol[indexPath.row]
        cell.labelPrice?.text = arrPrice[indexPath.row]
        cell.labelName?.text = arrName[indexPath.row]
        
        if ((arrChange[indexPath.row] as NSString).floatValue < 0){
            
            cell.imageViewChange.image = UIImage(systemName: "chevron.down.circle")
            cell.imageViewChange.tintColor = UIColor.red
            cell.labelChange?.text = arrChange[indexPath.row]
            cell.labelChange?.textColor = UIColor.red
            
        } else {
            
            cell.imageViewChange.image = UIImage(systemName: "chevron.up.circle")
            cell.imageViewChange.tintColor = UIColor.green
            cell.labelChange?.text = arrChange[indexPath.row]
            cell.labelChange?.textColor = UIColor.green
            
        }
        
        
        // BUTTON FAVORITE
        cell.favoriteFunc = {[unowned self] in
            
            let outletfavorite = UIImage(systemName: "hand.thumbsup.fill")
            
            cell.outletFavorite.setImage(outletfavorite, for: .normal)
            arrFavoriteIndex.append(indexPath.row)
            userDefaults.set(arrFavoriteIndex, forKey: "theScore")
            print(arrFavoriteIndex)
            
        }
        
        return cell
    }
}
