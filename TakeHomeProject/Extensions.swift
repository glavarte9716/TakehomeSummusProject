//
//  Extensions.swift
//  TakeHomeProject
//
//  Created by Gabe Lavarte on 1/25/23.
//

import Foundation
import UIKit
extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UIStackView {
    func setupForAuthorHeader() {
        distribution = .fillEqually
        alignment = .fill
        spacing = 1
        axis = .vertical
        translatesAutoresizingMaskIntoConstraints = false
        for view in self.arrangedSubviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
