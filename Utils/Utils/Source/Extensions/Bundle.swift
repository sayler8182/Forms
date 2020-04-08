//
//  Bundle.swift
//  Utils
//
//  Created by Konrad on 3/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public extension Bundle {
    func instantiate(with owner: UIView) -> UIView! {
        let name: String = String(describing: type(of: owner))
        let nib: UINib = UINib(nibName: name, bundle: self)
        let view: UIView? = nib.instantiate(withOwner: owner, options: nil).first as? UIView
        return view
    }
}
