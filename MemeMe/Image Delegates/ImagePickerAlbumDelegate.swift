//
//  ImagePickerDelegate.swift
//  MemeMe
//
//  Created by Hamna Usmani on 5/20/18.
//  Copyright © 2018 Hamna Usmani. All rights reserved.
//

import Foundation
import UIKit

class ImagePickerAlbumDelegate: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        dismiss(animated: true, compilation: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, compilation: nil)
    }
    
}

