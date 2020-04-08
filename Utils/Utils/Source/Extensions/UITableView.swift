//
//  UITableView.swift
//  Utils
//
//  Created by Konrad on 3/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public extension UITableView {
    func animated(_ animated: UITableView.RowAnimation,
                  action: () -> Void) {
        animated != .none
            ? action()
            : UIView.performWithoutAnimation(action)
    }
}
