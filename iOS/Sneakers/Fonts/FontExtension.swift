//
//  File.swift
//  
//
//  Created by Evgeny Serdyukov on 13.06.2022.
//
import UIKit
import SwiftUI


extension Font {
    static func ralewayRegular(size: CGFloat) -> Font {
        let name = "Raleway-Regular"
        assert(UIFont(name: name, size: size) != nil)
        return Font.custom(name, size: size)
    }

    static func ralewayMedium(size: CGFloat) -> Font {
        let name = "Raleway-Medium"
        assert(UIFont(name: name, size: size) != nil)
        return Font.custom(name, size: size)
    }

    static func ralewayBold(size: CGFloat) -> Font {
        let name = "Raleway-Bold"
        assert(UIFont(name: name, size: size) != nil)
        return Font.custom(name, size: size)
    }

    static func ralewaySemiBold(size: CGFloat) -> Font {
        let name = "Raleway-SemiBold"
        assert(UIFont(name: name, size: size) != nil)
        return Font.custom(name, size: size)
    }

    static func checkAllFonts() {
        let familyNames = UIFont.familyNames

        for family in familyNames {
            print("Family name " + family)
            let fontNames = UIFont.fontNames(forFamilyName: family)

            for font in fontNames {
                print("    Font name: " + font)
            }
        }
    }
}
