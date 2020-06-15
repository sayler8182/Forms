//
//  SocialKit.swift
//  FormsSocialKit
//
//  Created by Konrad on 6/13/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsInjector
import UIKit

// MARK: ThemeColorsKey
public extension ThemeColorsKey {
    static var appleSocialKit = ThemeColorsKey("appleSocialKit")
    static var facebookSocialKit = ThemeColorsKey("facebookSocialKit")
    static var googleSocialKit = ThemeColorsKey("googleSocialKit")
}

// MARK: ThemeColorsProtocol
public extension ThemeColorsProtocol {
    var appleSocialKit: UIColor {
        return self.color(.appleSocialKit)
    }
    
    var facebookSocialKit: UIColor {
        return self.color(.facebookSocialKit)
    }
    
    var googleSocialKit: UIColor {
        return self.color(.googleSocialKit)
    }
}

// MARK: SocialKit
public enum SocialKit {
    public static func configure() {
        let lightTheme: ThemeColorsProtocol? = Injector.main.resolve(ThemeType.light.key)
        lightTheme?.register([
            .appleSocialKit: UIColor.black,
            .facebookSocialKit: UIColor(0x3B5998),
            .googleSocialKit: UIColor(0xDF4930)
        ])
        let darkTheme: ThemeColorsProtocol? = Injector.main.resolve(ThemeType.dark.key)
        darkTheme?.register([
            .appleSocialKit: UIColor.white,
            .facebookSocialKit: UIColor(0x3B5998),
            .googleSocialKit: UIColor(0xDF4930)
        ])
    }
}
