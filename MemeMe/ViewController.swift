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
    
    //Delegate
    let textFieldDelegate = TextFieldDelegate()
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.textAlignment = .center
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
        self.textFieldAttributes(topTextField)
        self.textFieldAttributes(bottomTextField)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Unsubscribing from keyboard notifications
        unsubscribeFromKeyboardNotifications()
    }

    //Picking image from Album
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        self.presentImagePickerController(.photoLibrary)
    }
  
    //Capturing a picture from Camera
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        self.presentImagePickerController(.camera)
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
        }
    
    
    
    //Sharing the Meme Image
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
                self.saveMeme(memedImage)
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
    
    //Assigning attributes to text fields
    func textFieldAttributes(_ textField: UITextField){
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = textFieldDelegate
        
    }
    
    //Presenting controller to capture Image or open Album
    func presentImagePickerController(_ sourceType: UIImagePickerControllerSourceType){
        let pickerController = UIImagePickerController()
        pickerController.sourceType = sourceType
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
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

