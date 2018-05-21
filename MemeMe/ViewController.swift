//
//  ViewController.swift
//  MemeMe
//
//  Created by Hamna Usmani on 5/20/18.
//  Copyright © 2018 Hamna Usmani. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    //Delegates
    let topTextFieldDelegate = TopTextFieldDelegate()
    let bottomTextFieldDelegate = BottomTextFieldDelegate()
    
    //Attributes of text in text fields
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -3]

    //Properties of MemedImage
    struct MemedImage {
        let imageTopText: String
        let imageBottomText: String
        let image: UIImage
        let memedImage: UIImage
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Subscribing to keyboard notifications
        subscribeToKeyboardNotifications()
        
        //Checking if device has camera available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //Enabling share button only when image is selected
        shareButton.isEnabled = imagePickerView.image != nil
        
        //Assigning delegates and text attributes
        topTextField.delegate = topTextFieldDelegate
        topTextField.defaultTextAttributes = memeTextAttributes
        
        bottomTextField.delegate = bottomTextFieldDelegate
        bottomTextField.defaultTextAttributes = memeTextAttributes
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Unsubscribing from keyboard notifications
        unsubscribeFromKeyboardNotifications()
    }

    //Picking image from Album
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
  
    //Capturing a picture from Camera
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .camera
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    //Generating Meme Image by taking screenshot
    func generateMemedImage() -> UIImage {
        //Hiding toolbars
        topToolBar.isHidden = true
        bottomToolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        //Enabling tool bars
        topToolBar.isHidden = false
        bottomToolBar.isHidden = false
        
        UIGraphicsEndImageContext()
        return memedImage
        
    }
    
    //Saving generated meme image
    func saveMeme(_ memedImage: UIImage) {
        let memeImage = MemedImage(imageTopText: topTextField.text!, imageBottomText: bottomTextField.text!, image: imagePickerView.image!, memedImage: memedImage)
        
        let imageName = memeImage.imageTopText
        
        //create an instance of the FileManager
        let fileManager = FileManager.default
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        
        //get the PNG data for this image
        let data = UIImagePNGRepresentation(memeImage.memedImage)
        
        //store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
    }
    
    
    
    //Sharing the Meme Image
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed { // User canceled
                return
            }else{  // User completed activity
                self.saveMeme(memedImage)
                return
            }
        }
        present(controller, animated: true, completion: nil)
    }
    
    
    //Clearing image and text fields when Cancel called
    @IBAction func cancelMeme(_ sender: Any) {
        imagePickerView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
    
    
    //Image delegate function - Image selected/captured
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        self.dismiss(animated: true, completion: nil)
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            imagePickerView.image = image
        }
    }
    
    //Image delegate - Cancelled image selection
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Adjusting y axis to show bottom text field alongwith keyboad
    @objc func keyboardWillShow(_ notification:Notification) {
        if(bottomTextField.isFirstResponder){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //Pushing Y axis downward
    @objc func keyboardWillHide(){
        view.frame.origin.y = 0
        
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    //Subscribing to Keyboard Notifications
    func subscribeToKeyboardNotifications(){
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    //Unsubscribing from Keyboard Notifications
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}

