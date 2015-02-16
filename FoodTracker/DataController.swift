//
//  DataController.swift
//  FoodTracker
//
//  Created by Marko Budal on 16/02/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let kUSDAItemCompleted = "USDAItemInstanceComplete"
class DataController {

    class func jsonAsUSDAIdAndNameSearchResults(json : NSDictionary) -> [(name:String, idValue:String)] {
    
        var usdaItemSearchResults:[(name:String, idValue:String)] = []
        var searchResults: (name:String, idValue: String)
        
        if json["hits"] != nil {
            let results:[AnyObject] = json["hits"]! as [AnyObject]
            
            for itemDictionary in results {
                if itemDictionary["_id"] != nil {
                    if itemDictionary["fields"] != nil {
                        let fieldsDictionary = itemDictionary["fields"] as NSDictionary
                        
                        if fieldsDictionary["item_name"] != nil {
                            let idValue:String = itemDictionary["_id"]! as String
                            let name:String = fieldsDictionary["item_name"]! as String
                            searchResults = (name: name, idValue: idValue)
                            usdaItemSearchResults += [searchResults]
                        }
                    }
                }
            }
        }
        return usdaItemSearchResults
    }
    
    func saveUSDAItemForIS(idValue:String, json: NSDictionary) {
        if json["hits"] != nil {
            let results:[AnyObject] = json["hits"]! as [AnyObject]
            
            for itemDictionary in results {
                if itemDictionary["_id"] != nil && itemDictionary["_id"] as String == idValue {
                    let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
                    let managedObjectContext = appDelegate.managedObjectContext 
                    var requestForUSDAItem = NSFetchRequest(entityName: "USDAItem")
                    let itemDictionaryId = itemDictionary["_id"]! as String
                    
                    let predicate = NSPredicate(format: "idValue == %@", itemDictionaryId)
                    requestForUSDAItem.predicate = predicate
                    
                    var error: NSError?
                    
                    var items = managedObjectContext?.executeFetchRequest(requestForUSDAItem, error: &error)
                    
                    if items?.count != 0 {
                        //item is already saved
                        println("The item was already saved")
                        return
                    }else {
                        println("Lets save this to CoreData")
                        let entityDescription = NSEntityDescription.entityForName("USDAItem", inManagedObjectContext: managedObjectContext!)
                        let usdaItem = USDAItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
                        
                        usdaItem.idValue = itemDictionary["_id"]! as String
                        usdaItem.dateAdded = NSDate()
                        
                        if itemDictionary["fields"] != nil {
                            let fieldsDictionary = itemDictionary["fields"]! as NSDictionary
                            
                            if fieldsDictionary["item_name"] != nil {
                                usdaItem.name = fieldsDictionary["item_name"]! as String
                            }
                            if fieldsDictionary["usda_fields"] != nil {
                                let usdaFieldsDictionary = fieldsDictionary["usda_fields"]! as NSDictionary
                                
                                if usdaFieldsDictionary["CA"] != nil {
                                    let calciumDictionary = usdaFieldsDictionary["CA"]! as NSDictionary
                                    let calciumValue:AnyObject = calciumDictionary["value"]!
                                    usdaItem.calcium = "\(calciumValue)"
                                }else{
                                    usdaItem.calcium = "0"
                                }
                                
                                if usdaFieldsDictionary["CHOCDF"] != nil {
                                    let carbohydrateDictionary = usdaFieldsDictionary["CHOCDF"] as NSDictionary
                                    if carbohydrateDictionary["value"] != nil {
                                        let carbohydrateValue:AnyObject = carbohydrateDictionary["value"]!
                                        usdaItem.carbohydrate = "\(carbohydrateValue)"
                                    }else{
                                        usdaItem.carbohydrate = "0"
                                    }
                                }
                                
                                if usdaFieldsDictionary["FAT"] != nil {
                                    let fatDictionary = usdaFieldsDictionary["FAT"] as NSDictionary
                                    if fatDictionary["value"] != nil {
                                        let fatValue: AnyObject = fatDictionary["value"]!
                                        usdaItem.fatTotal = "\(fatValue)"
                                    }else {
                                        usdaItem.fatTotal = "0"
                                    }
                                }
                                
                                if usdaFieldsDictionary["CHOLE"] != nil {
                                    let cholesterolDictionary = usdaFieldsDictionary["CHOLE"]! as NSDictionary
                                    if cholesterolDictionary["value"] != nil {
                                        let choresterolValue: AnyObject = cholesterolDictionary["value"]!
                                        usdaItem.cholesterol = "\(choresterolValue)"
                                    }else {
                                        usdaItem.cholesterol = "0"
                                    }
                                }
                                
                                if usdaFieldsDictionary["PROCNT"] != nil {
                                    let proteinDictionary = usdaFieldsDictionary["PROCNT"]! as NSDictionary
                                    if proteinDictionary["value"] != nil {
                                        let proteinValue: AnyObject = proteinDictionary["value"]!
                                        usdaItem.protein = "\(proteinValue)"
                                    }else {
                                        usdaItem.protein = "0"
                                    }
                                }
                                
                                if usdaFieldsDictionary["SUGAR"] != nil {
                                    let sugarDictionary = usdaFieldsDictionary["SUGAR"]! as NSDictionary
                                    if sugarDictionary["value"] != nil {
                                        let sugarValue: AnyObject = sugarDictionary["value"]!
                                        usdaItem.sugar = "\(sugarValue)"
                                    }else {
                                        usdaItem.sugar = "0"
                                    }
                                }
                                
                                if usdaFieldsDictionary["VITC"] != nil {
                                    let vitamiCDictionary = usdaFieldsDictionary["VITC"]! as NSDictionary
                                    if vitamiCDictionary["value"] != nil {
                                        let vitamiCValue: AnyObject = vitamiCDictionary["value"]!
                                        usdaItem.vitamiC = "\(vitamiCValue)"
                                    }else {
                                        usdaItem.vitamiC = "0"
                                    }
                                }
                                
                                if usdaFieldsDictionary["ENERC_KCAL"] != nil {
                                    let energyDictionary = usdaFieldsDictionary["ENERC_KCAL"]! as NSDictionary
                                    if energyDictionary["value"] != nil {
                                        let energyValue: AnyObject = energyDictionary["value"]!
                                        usdaItem.energy = "\(energyValue)"
                                    }else {
                                        usdaItem.energy = "0"
                                    }
                                }
                                
                                (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()

                                NSNotificationCenter.defaultCenter().postNotificationName(kUSDAItemCompleted, object: usdaItem)
                               
                                
                            }
                            
                            
                        }
                    }
                }
            }
        }
    }
}
