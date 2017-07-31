//
//  FirstViewController.swift
//  TravelExpense
//
//  Created by Thomas Nugent on 29/07/2017.
//  Copyright © 2017 Thomas Nugent. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = #imageLiteral(resourceName: "yuppie")
        let imageView = UIImageView(image: image)
        let x = navBar.frame.size.width / 2 - image.size.width / 2
        let y = navBar.frame.size.height / 2 - image.size.height / 2
        
        imageView.frame = CGRect(x: x, y: y, width: navBar.frame.size.width, height: navBar.frame.size.height - 5)
        imageView.contentMode = .scaleAspectFit
        navBar.topItem?.titleView = imageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

