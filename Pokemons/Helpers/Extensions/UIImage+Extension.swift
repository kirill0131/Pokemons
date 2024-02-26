//
//  UIImage+Extension.swift
//  Pokemons
//
//  Created by Kirill Orlov on 26.02.24.
//

import UIKit

extension UIImage {
    var hasAlphaChannel: Bool {
        guard let alpha = cgImage?.alphaInfo else {
            return false
        }
        return alpha == .first || alpha == .last || alpha == .premultipliedFirst || alpha == .premultipliedLast
    }
}
