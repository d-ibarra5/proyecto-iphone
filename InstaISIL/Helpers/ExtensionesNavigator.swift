//
//  ExtensionesNavigator.swift
//  InstaISIL
//
//  Created by user179030 on 12/13/20.
//  Copyright © 2020 isil. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {

    func backToViewController(viewController: Swift.AnyClass) {

            for element in viewControllers as Array {
                if element.isKind(of: viewController) {
                    self.popToViewController(element, animated: true)
                break
            }
        }
    }
}
