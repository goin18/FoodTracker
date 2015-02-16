//
//  DetailViewController.swift
//  FoodTracker
//
//  Created by Marko Budal on 15/02/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var usdaItem: USDAItem?
    
    @IBOutlet weak var textView: UITextView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "usdaItemDidComplete:", name: kUSDAItemCompleted, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if usdaItem != nil {
            textView.attributedText = createAttributeString(usdaItem)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func usdaItemDidComplete(notification: NSNotification) {
        println("usdaItemDidComplete in DetailViewController")
        usdaItem = notification.object as? USDAItem
        
        if self.isViewLoaded() && self.view.window != nil {
            textView.attributedText = createAttributeString(usdaItem!)
        }
        
    }
    
    @IBAction func eatItBarButtonPressed(sender: UIBarButtonItem) {
    }
    
    func createAttributeString(usdaItem: USDAItem!) -> NSAttributedString {
        var itemAttributetString = NSMutableAttributedString()
        
        var centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = NSTextAlignment.Center
        centeredParagraphStyle.lineSpacing = 10.0
        var titleAttributesDictionary = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont.boldSystemFontOfSize(22.0),
            NSParagraphStyleAttributeName: centeredParagraphStyle
        ]
        let titleString = NSAttributedString(string: "\(usdaItem.name)\n", attributes: titleAttributesDictionary)
        itemAttributetString.appendAttributedString(titleString)
        
        
        var leftAllignedParagraphStyle = NSMutableParagraphStyle()
        leftAllignedParagraphStyle.alignment = NSTextAlignment.Left
        leftAllignedParagraphStyle.lineSpacing = 20.0
        var styleFirstWordAttrubutesDictionary = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0),
            NSParagraphStyleAttributeName: leftAllignedParagraphStyle
        ]
        
        var style1AttributeDictionary = [
            NSForegroundColorAttributeName: UIColor.darkGrayColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(18.0),
            NSParagraphStyleAttributeName: leftAllignedParagraphStyle
        ]
        
        var style2AttributeDictionary = [
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(18.0),
            NSParagraphStyleAttributeName: leftAllignedParagraphStyle
        ]
        
        
        let calciumTitleString = NSAttributedString(string: "Calcium: ", attributes: style1AttributeDictionary)
        let calciumBodyString = NSAttributedString(string: "\(usdaItem.calcium)%\n", attributes: style1AttributeDictionary)
        itemAttributetString.appendAttributedString(calciumTitleString)
        itemAttributetString.appendAttributedString(calciumBodyString)
        
        let carbohydrateTitleString = NSAttributedString(string: "Carbohydrate: ", attributes: style1AttributeDictionary)
        let carbohybrateBodyString = NSAttributedString(string: "\(usdaItem.carbohydrate) \n", attributes: style2AttributeDictionary)
        itemAttributetString.appendAttributedString(carbohydrateTitleString)
        itemAttributetString.appendAttributedString(carbohybrateBodyString)
        
        let cholesterolTitleString = NSAttributedString(string: "Cholesterol: ", attributes: style1AttributeDictionary)
        let cholesterolBodyString = NSAttributedString(string: "\(usdaItem.cholesterol) \n", attributes: style2AttributeDictionary)
        itemAttributetString.appendAttributedString(cholesterolTitleString)
        itemAttributetString.appendAttributedString(cholesterolBodyString)
        
        let energyTitleString = NSAttributedString(string: "Energy: ", attributes: style1AttributeDictionary)
        let energyBodyString = NSAttributedString(string: "\(usdaItem.energy)% \n", attributes: style2AttributeDictionary)
        itemAttributetString.appendAttributedString(energyTitleString)
        itemAttributetString.appendAttributedString(energyBodyString)
        
        let fatTotalTitleString = NSAttributedString(string: "Fat Total: ", attributes: style1AttributeDictionary)
        let fatTotalBodyString = NSAttributedString(string: "\(usdaItem.fatTotal)% \n", attributes: style2AttributeDictionary)
        itemAttributetString.appendAttributedString(fatTotalTitleString)
        itemAttributetString.appendAttributedString(fatTotalBodyString)
        
        let proteinTitleString = NSAttributedString(string: "Protein: ", attributes: style1AttributeDictionary)
        let proteinBodyString = NSAttributedString(string: "\(usdaItem.protein)% \n", attributes: style2AttributeDictionary)
        itemAttributetString.appendAttributedString(proteinTitleString)
        itemAttributetString.appendAttributedString(proteinBodyString)
        
        let sugarTitleString = NSAttributedString(string: "Sugar", attributes: style1AttributeDictionary)
        let sugarBodyString = NSAttributedString(string: "\(usdaItem.sugar)% \n", attributes: style2AttributeDictionary)
        itemAttributetString.appendAttributedString(sugarTitleString)
        itemAttributetString.appendAttributedString(sugarBodyString)
        
        let vitaminCTitleString = NSAttributedString(string: "Vitamin C: ", attributes: style1AttributeDictionary)
        let vitaminCBodyString = NSAttributedString(string: "\(usdaItem.vitamiC) \n", attributes: style2AttributeDictionary)
        itemAttributetString.appendAttributedString(vitaminCTitleString)
        itemAttributetString.appendAttributedString(vitaminCBodyString)
        
        return itemAttributetString
    }
    
    
}
