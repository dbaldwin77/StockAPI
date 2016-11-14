//
//  ViewController.swift
//  StockAPI
//
//  Created by Developer on 11/12/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class StocksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    @IBOutlet weak var enterTicker: UITextField!

    @IBOutlet weak var tickerView: UILabel!
    
    @IBOutlet weak var percentView: UILabel!
    
  
    var percentd = 0.0
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tableView.endEditing(true)
        view.endEditing(true)
    }
    
    @IBAction func addTicker(_ sender: UIButton) {
        let ticker = (enterTicker.text!,0.0)
      
        let tickerPercent = (ticker)
        
          
        stocks.append(tickerPercent)
        self.enterTicker.text = "  "
        updateStocks()
       StockManager.sharedInstance.updateListOfSymbols(stocks)
        
        
    }
        var stocks: [(String,Double)] = [("AAPL",0.0),("GOOG",0.0),("HAL",0.0),("YHOO",0.0),("TSLA",0.0),("TSLA",0.0),("T",0.0),("NBL",0.0),("APC",0.0),("CPE",0.0),("ANF",0.0)]

    @IBOutlet weak var tableView: UITableView!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            NotificationCenter.default.addObserver(self, selector: #selector(StocksViewController.stocksUpdated(_:)), name: NSNotification.Name(rawValue: kNotificationStocksUpdated), object: nil)
            percentView.text = nil
            self.updateStocks()
          
       
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
    
          func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
                let addedRow = isEditing ? 1 : 0
            
             return stocks.count + addedRow
        }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        

            cell.textLabel!.text = stocks[indexPath.row].0
            cell.detailTextLabel!.text = "\(stocks[indexPath.row].1)" + "%"
        return cell
        }
    func updateView() {
        
        
    }
         func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let stockManager:StockManager = StockManager.sharedInstance
            stockManager.printTest()
            
            tickerView!.text = stocks[indexPath.row].0
            percentView!.text = "\(stocks[indexPath.row].1)" + "%"
            
            updateStocks()
            
            NSLog("cell clicked")
            
        }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     
        switch stocks[indexPath.row].1 {
        case let x where x < 0.0:
            cell.detailTextLabel!.backgroundColor = UIColor.red
          
        case let x where x > 0.0:
            cell.detailTextLabel!.backgroundColor = UIColor.green
    
        default:
            cell.detailTextLabel!.backgroundColor = UIColor.gray
      
        }
        cell.textLabel!.font = UIFont(name: "HelveticaNeue-Condensed", size: 40)
        cell.detailTextLabel!.font = UIFont(name: "HelveticaNeue-Condensed", size: 40)
        cell.textLabel!.shadowColor = UIColor.gray
        cell.textLabel!.shadowOffset = CGSize(width: 1, height: 2)
        cell.detailTextLabel!.shadowColor = UIColor.darkGray
        cell.detailTextLabel!.shadowOffset = CGSize(width: 1, height: 2)
        
        
        tickerView.backgroundColor = UIColor.darkGray
        tickerView!.shadowColor = UIColor.gray
        tickerView!.shadowOffset = CGSize(width: 1, height: 2)
        percentView!.shadowColor = UIColor.darkGray
        percentView!.shadowOffset = CGSize(width: 1, height: 2)
        if percentView.text == nil {
            percentView.backgroundColor = UIColor.darkGray
        } else if percentView.text! < "0.0"{
            percentView.backgroundColor = UIColor.red
        } else if percentView.text! > "0.0"{
                percentView.backgroundColor = UIColor.green
        } else {
             percentView.backgroundColor = UIColor.darkGray
        }
        
    }
    
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return 55
    }
    func updateStocks() {
        let stockManager:StockManager = StockManager.sharedInstance
        stockManager.updateListOfSymbols(stocks)
        
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(20 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: {
                self.updateStocks()
            }
        )
    }
    
    func stocksUpdated(_ notification: Notification) {
        let values = (notification.userInfo as! Dictionary<String,NSArray>)
        let stocksReceived:NSArray = values[kNotificationStocksUpdated]!
        stocks.removeAll(keepingCapacity: false)
        for quote in stocksReceived {
            let quoteDict:NSDictionary = quote as! NSDictionary
            let changeInPercentString = quoteDict["ChangeinPercent"] as! String
            let changeInPercentStringClean: NSString = (changeInPercentString as NSString).substring(to: changeInPercentString.characters.count-1) as NSString
            stocks.append(quoteDict["symbol"] as! String,changeInPercentStringClean.doubleValue)
        }
        tableView.reloadData()
        NSLog("Symbols Values updated :)")
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            stocks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
