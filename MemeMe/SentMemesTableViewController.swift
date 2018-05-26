//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Hamna Usmani on 5/26/18.
//  Copyright © 2018 Hamna Usmani. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var memes : [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    @objc func createNewMeme(){
        let memeCreateVC = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        present(memeCreateVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(memes.isEmpty){
            self.createNewMeme()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createNewMeme))
    }
    

    //Number of rows in Meme Array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.memes.count)
        return self.memes.count
    }
    
    //Custom populate each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let meme = memes[indexPath.row]
        
        cell.textLabel?.text = meme.imageTopText
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    //Handle click on cell
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sentMemeDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "SentMemeDetailViewController") as! SentMemeDetailViewController
        
        sentMemeDetailVC.meme = memes[indexPath.row]
        self.navigationController?.pushViewController(sentMemeDetailVC, animated: true)
    }
}
