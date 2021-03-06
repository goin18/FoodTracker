//
//  ViewController.swift
//  FoodTracker
//
//  Created by Marko Budal on 15/02/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    
    let kAppId = "0ad7dc37"
    let kAppKey = "fa3b1c53ed3a8284dd7d6c04b0038999"
    
    var searchController:UISearchController!
    
    var suggestedSearchFoods:[String] = []
    var filteredSuggestedSearchFoods:[String] = []
   // var favoritedUSDAItem:[String] = []
    
    var apiSearchForFoods:[(name: String, idValue: String)] = []
    
    var table:[USDAItem] = []
    var filteredFavoritedUSDAItems:[USDAItem] = []
    var favoritedUSDAItem:[USDAItem] = []
    
    var scopeButtonTitles = ["Reccommended", "Search Results", "Saved"]
    
    var jsonResponse:NSDictionary!
    
    var dataController = DataController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.scopeButtonTitles = self.scopeButtonTitles
        
        self.searchController.searchBar.delegate = self
        
        self.definesPresentationContext = true
        
        self.suggestedSearchFoods = ["apple", "bagel", "banana", "beer", "bread", "carrots", "cheddar cheese", "chicen breast", "chili with beans", "chocolate chip cookie", "coffee", "cola", "corn", "egg", "graham cracker", "granola bar", "green beans", "ground beef patty", "hot dog", "ice cream", "jelly doughnut", "ketchup", "milk", "mixed nuts", "mustard", "oatmeal", "orange juice", "peanut butter", "pizza", "pork chop", "potato", "potato chips", "pretzels", "raisins", "ranch salad dressing", "red wine", "rice", "salsa", "shrimp", "spaghetti", "spaghetti sauce", "tuna", "white wine", "yellow cake"]
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "usdaItemDidComplete:", name: kUSDAItemCompleted, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDetailVCSegue" {
            if sender != nil {
                var detailVC = segue.destinationViewController as! DetailViewController
                detailVC.usdaItem = sender as? USDAItem
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UItableViewDataSorce
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
        if selectedScopeButtonIndex == 0 {
            if self.searchController.active {
                return filteredSuggestedSearchFoods.count
            }else {
                return suggestedSearchFoods.count
            }
        }else if selectedScopeButtonIndex == 1 {
            return self.apiSearchForFoods.count
        } else {
            if self.searchController.active {
                return self.filteredFavoritedUSDAItems.count
            }else{
                return self.favoritedUSDAItem.count
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        var foodName:String
        
        let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
        
        if selectedScopeButtonIndex == 0 {
            if self.searchController.active {
                foodName = filteredSuggestedSearchFoods[indexPath.row]
            }else {
                foodName = suggestedSearchFoods[indexPath.row]
            }
        }else if selectedScopeButtonIndex == 1 {
            foodName = apiSearchForFoods[indexPath.row].name
        } else{
            if searchController.active {
                foodName = self.filteredFavoritedUSDAItems[indexPath.row].name
            }else {
                foodName = self.favoritedUSDAItem[indexPath.row].name
            }
        }
        
        cell.textLabel?.text = foodName
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    //UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedScopeBatButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
        
        if selectedScopeBatButtonIndex == 0 {
            var searchFoodName: String
            if self.searchController.active {
                searchFoodName = filteredSuggestedSearchFoods[indexPath.row]
            }else{
                searchFoodName = suggestedSearchFoods[indexPath.row]
            }
            self.searchController.searchBar.selectedScopeButtonIndex = 1
            makeRequest(searchFoodName)
            
        } else if selectedScopeBatButtonIndex == 1 {
            self.performSegueWithIdentifier("toDetailVCSegue", sender: nil)
            let idValue = apiSearchForFoods[indexPath.row].idValue
            dataController.saveUSDAItemForIS(idValue, json: jsonResponse)
            
        
        } else if selectedScopeBatButtonIndex == 2 {
            if searchController.active {
                let usdaItem = filteredFavoritedUSDAItems[indexPath.row]
                self.performSegueWithIdentifier("toDetailVCSegue", sender: usdaItem)
            }else{
                let usdaItem = favoritedUSDAItem[indexPath.row]
                self.performSegueWithIdentifier("toDetailVCSegue", sender: usdaItem)
            }
        }
        
    }
    
    // UISearchResultsUpdateing
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
        
        self.filterContentForSearch(searchString, scope: selectedScopeButtonIndex)
        self.tableView.reloadData()
    }
    
    func filterContentForSearch(searchText:String, scope:Int) {
        if searchText != "" {
            if scope == 0 {
                self.filteredSuggestedSearchFoods = self.suggestedSearchFoods.filter({ (food:String) -> Bool in
                    var foodMatch = food.rangeOfString(searchText)
                    return foodMatch != nil
                })
            }else if scope == 2 {
                self.filteredFavoritedUSDAItems = self.favoritedUSDAItem.filter({ (item: USDAItem) -> Bool in
                    var stringMatch = item.name.rangeOfString(searchText)
                    return stringMatch != nil
                })
            }
        }
        
    }
    
    
    // UISearchBarDelegat
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchController.searchBar.selectedScopeButtonIndex = 1
        makeRequest(searchBar.text)
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        if selectedScope == 2 {
            requestFavoriteUSDAItems()
        }
        
        self.tableView.reloadData()
    }
    
    func makeRequest(searchString: String) {
//https://api.nutritionix.com/v1_1/search/
        //HTTP Get Request
        /*
        let url = NSURL(string: "\(searchString)?results=0%3A5&cal_min=0&cal_max=50000&fields=item_name%2Cbrand_name%2Citem_id%2Cbrand_id&appId=\(kAppId)&appKey=\(kAppKey)")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            var stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            println(stringData)
            println(response)
        })
        task.resume()
        */
        
        
        var request = NSMutableURLRequest(URL: NSURL(string: "https://api.nutritionix.com/v1_1/search/")!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = [
            "appId": kAppId,
            "appKey": kAppKey,
            "fields": ["item_name", "brand_name", "keywords", "usda_fields"],
            "limit": "5",
            "query": searchString,
            "filters":["exists":["usda_fields":true]]
        ]
        
        var error:NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: { (data, response, err) -> Void in
            
          //  var stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
            var conversionError: NSError?
            var jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: &conversionError) as? NSDictionary
          //  println(jsonDictionary)
            
            if conversionError != nil {
                println(conversionError!.localizedDescription)
                let errorString = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error in Parsing \(errorString)")
            }else {
                if jsonDictionary != nil {
                    self.jsonResponse = jsonDictionary
                    self.apiSearchForFoods += DataController.jsonAsUSDAIdAndNameSearchResults(jsonDictionary!)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                }else {
                    let errorString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error in Parsing \(errorString)")

                }
            
            }
        })
        task.resume()
        
    }
    
    // Setup CoreData
    
    func requestFavoriteUSDAItems() {
        let fetchRequest = NSFetchRequest(entityName: "USDAItem")
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let managedObjectContext = appDelegate.managedObjectContext
        
        self.favoritedUSDAItem = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as! [USDAItem]
    }
    
    // NSNotificationCenter
    func usdaItemDidComplete(notification: NSNotification) {
        
        println("usdaItemDidComplete in ViewController")
        requestFavoriteUSDAItems()
        let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
        if selectedScopeButtonIndex == 2 {
            self.tableView.reloadData()
        }
    }
    
    



}

