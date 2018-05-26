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
    
    override func viewDidLoad() {
        print("---LOADED-----")
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memeImageView!.image = meme.memedImage
    }
}
