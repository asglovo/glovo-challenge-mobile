
//
//  UIColor+Random.swift
//  Glovo
//
//  Created by Anıl Sözeri on 29.06.2018.
//  Copyright © 2018 Anıl Sözeri. All rights reserved.
//

import UIKit

extension UIColor {
  func randomColor() -> UIColor {
    let red: CGFloat = CGFloat(drand48())
    let green: CGFloat = CGFloat(drand48())
    let blue: CGFloat = CGFloat(drand48())
    
    return UIColor(red: red, green: green, blue: blue, alpha: 1)
  }
}
