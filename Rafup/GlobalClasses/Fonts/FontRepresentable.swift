// FontRepresentable.swift
//
//  Created by Ashish on 14/02/18.
//  Copyright © 2018 DS. All rights reserved.
//

import UIKit

public protocol FontRepresentable: RawRepresentable {}

extension FontRepresentable where Self.RawValue == String {
    /// An alternative way to get a particular `UIFont` instance from a `Font`
    /// value.
    ///
    /// - parameter of size: The desired size of the font.
    ///
    /// - returns a `UIFont` instance of the desired font family and size, or
    /// `nil` if the font family or size isn't installed.
    public func of(size: CGFloat) -> UIFont? {
        return UIFont(name: rawValue, size: size)
    }

    public func of(size: Double) -> UIFont? {
        return UIFont(name: rawValue, size: CGFloat(size))
    }
}
