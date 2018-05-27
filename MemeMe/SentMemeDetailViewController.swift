//
//  SentMemeDetailViewController.swift
//  MemeMe
//
//  Created by Hamna Usmani on 5/26/18.
//  Copyright © 2018 Hamna Usmani. All rights reserved.
//

import UIKit

class SentMemeDetailViewController: UIViewController {
    
    var meme: Meme!

    @IBOutlet weak var memeImageView: UIImageView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.memeImageView!.image = meme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
}
