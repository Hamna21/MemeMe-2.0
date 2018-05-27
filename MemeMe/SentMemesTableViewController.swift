//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Hamna Usmani on 5/26/18.
//  Copyright © 2018 Hamna Usmani. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var memes : [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }

    //Presenting Memes Editor View
    func openMemeEditor(){
        let memeCreateVC = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        present(memeCreateVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Opening Memes Editor if Memes Array is empty
        if(memes.isEmpty){
            self.openMemeEditor()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        self.tableView.reloadData()
    }
    
    //Click on Navigation right iten
    @IBAction func createNewMemes(_ sender: Any) {
        openMemeEditor()
    }

    //Number of rows in Meme Array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    //Custom populate each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let meme = memes[indexPath.row]
        
        cell.imageView?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        cell.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        cell.textLabel?.textAlignment = .right
        
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.imageTopText + meme.imageBottomText
        
        return cell
    }
    
   
    //Handle click on each cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sentMemeDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "SentMemeDetailViewController") as! SentMemeDetailViewController
        
        sentMemeDetailVC.meme = memes[indexPath.row]
        self.navigationController?.pushViewController(sentMemeDetailVC, animated: true)
    }
}
