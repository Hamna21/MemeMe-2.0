//
//  TopTextDelegate.swift
//  MemeMe
//
//  Created by Hamna Usmani on 5/20/18.
//  Copyright © 2018 Hamna Usmani. All rights reserved.
//

import Foundation
import UIKit

class TopTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.text == "TOP"){
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
}
