//
//  Extensions.swift
//  SearchControllerTest
//
//  Created by Daniel Hjärtström on 2018-07-23.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit

extension UISearchBar {
    func setTextFieldApperence() {
        if let textfield = self.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.white
                backgroundview.layer.cornerRadius = 10.0
                backgroundview.clipsToBounds = true
            }
        }
    }
    
    func textfieldForSearchBar() -> UITextField? {
        if let textfield = self.value(forKey: "searchField") as? UITextField {
            return textfield
        }
        return nil
    }
}
