//
//  StockManager.swift
//  StockAPI
//
//  Created by Developer on 11/13/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation


let kNotificationStocksUpdated = "stocksUpdated"

class StockManager {
    
    class var sharedInstance : StockManager {
        struct Static {
            static let instance : StockManager = StockManager()
        }
        return Static.instance
    }
    
    func printTest() {
        NSLog("TEST OK :)")
    }
    func updateListOfSymbols(_ stocks:Array<(String,Double)>) ->() {
      
        var stringQuotes = "(";
        for quoteTuple in stocks {
            stringQuotes = stringQuotes+"\""+quoteTuple.0+"\","
        }
        stringQuotes = stringQuotes.substring(to: stringQuotes.characters.index(before: stringQuotes.endIndex))
        stringQuotes = stringQuotes + ")"
        
        let urlString:String = ("http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.quotes where symbol IN "+stringQuotes+"&format=json&env=http://datatables.org/alltables.env").addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url : URL = URL(string: urlString)!
        let request: URLRequest = URLRequest(url:url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
                let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            
            if((error) != nil) {
                print(error!.localizedDescription)
            }
            else {
                var err: NSError?
    
                do {
                 let jsonDict =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    

                
                if(err != nil) {
                    print("JSON Error \(err!.localizedDescription)")
                }
                
                else {
           
                    
                    let quotes:NSArray = ((jsonDict.object(forKey: "query") as! NSDictionary).object(forKey: "results") as! NSDictionary).object(forKey: "quote") as! NSArray
                    DispatchQueue.main.async(execute: {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: kNotificationStocksUpdated), object: nil, userInfo: [kNotificationStocksUpdated:quotes])
                        
                    })
                    
                }
            } catch {
                print("error")
            }
            
        }
        })
    
        task.resume()
    }
}
