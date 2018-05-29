//
//  SentMemeCollectionViewController.swift
//  MemeMe
//
//  Created by Hamna Usmani on 5/27/18.
//  Copyright © 2018 Hamna Usmani. All rights reserved.
//

import UIKit

class SentMemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet var collectionVIew: UICollectionView!
    
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 5.0
        let dimensionWidth = (view.frame.size.width - (2 * space))/3
        let dimensionHeight = (view.frame.size.height - (2 * space))/3
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimensionWidth, height: dimensionHeight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        self.collectionVIew.reloadData()
    }

    //Presenting Memes Editor View
    func openMemeEditor(){
        let memeCreateVC = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        present(memeCreateVC, animated: true, completion: nil)
    }
    
    
    @IBAction func createNewMemes(_ sender: Any) {
        openMemeEditor()
    }
    
    //Number of items in Memes Array
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    //Customize each cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as!
            SentMemesCollectionViewCell
        
        let meme = memes[indexPath.row]
        
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    //Handle click on each cell
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "SentMemeDetailViewController") as! SentMemeDetailViewController
        
        memeDetailVC.meme = memes[indexPath.row]
        
        self.navigationController?.pushViewController(memeDetailVC, animated: true)
    }
    

}
