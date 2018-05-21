//
//  MemeController.swift
//  MemeMe
//
//  Created by Hamna Usmani on 5/20/18.
//  Copyright © 2018 Hamna Usmani. All rights reserved.
//

import Foundation
import UIKit

class MemeController {
    struct memedImage {
        let imageTopText: String
        let imageBottomText: String
        let image: UIImage
        let memedImage: UIImage
        
    }
    
    func generateMemedImage() -> UIImage {
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    func shareMeme(){
        print("HELLOOO")
    }
}
