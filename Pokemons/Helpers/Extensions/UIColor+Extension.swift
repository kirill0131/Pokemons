//
//  UIColor+Extension.swift
//  Pokemons
//
//  Created by Kirill Orlov on 26.02.24.
//

import UIKit

extension UIColor {
    private static func createColorWithRGB(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    // #FEFFFF
    static var navBarColor: UIColor {
        return createColorWithRGB(254, 255, 255)
    }
    
    // #3AAFA9
    static var listColor: UIColor {
        return createColorWithRGB(58, 175, 169)
    }
    
    // #2B7A78
    static var listSecondColor: UIColor {
        return createColorWithRGB(43, 122, 120)
    }
    
    // #3AAFA9
    static var detailsColor: UIColor {
        return createColorWithRGB(58, 175, 169)
    }
    
    // #000000
    static var textColor: UIColor {
        return .black
    }
}
