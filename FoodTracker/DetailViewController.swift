//
//  DetailViewController.swift
//  FoodTracker
//
//  Created by Marko Budal on 15/02/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func eatItBarButtonPressed(sender: UIBarButtonItem) {
    }
}
