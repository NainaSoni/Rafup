// Font+Extension.swift
//
//  Created by Ashish on 14/02/18.
//  Copyright © 2018 DS. All rights reserved.
//

import UIKit

extension UIFont {
    /// Create a UIFont object with a `Font` enum
    public convenience init?(font: Font, size: CGFloat) {
        let fontIdentifier: String = font.rawValue
        self.init(name: fontIdentifier, size: size)
    }
    
    func withTraits(_ traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    func withoutTraits(_ traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(  self.fontDescriptor.symbolicTraits.subtracting(UIFontDescriptorSymbolicTraits(traits)))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    func bold() -> UIFont {
        return withTraits( .traitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(.traitItalic)
    }
    
    func noItalic() -> UIFont {
        return withoutTraits(.traitItalic)
    }
    func noBold() -> UIFont {
        return withoutTraits(.traitBold)
    }
    
    public static func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            printDebug("------------------------------")
            printDebug("Font Family Name = [\(familyName)]")
            let name = UIFont.fontNames(forFamilyName: familyName)
            printDebug("Font Name = [\(name)]")
        }
    }
}
