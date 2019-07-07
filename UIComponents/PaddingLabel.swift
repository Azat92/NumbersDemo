//
//  PaddingLabel.swift
//  UIComponents
//
//  Created by Azat Almeev on 07/07/2019.
//  Copyright © 2019 Azat Almeev. All rights reserved.
//

import UIKit

/// Default UILabel which adds padding when rendering a text
public final class PaddingLabel: UILabel {

    /// Padding to be applied on every side of label during rendering text
    public var padding: CGFloat = 32
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: padding, dy: padding))
    }
}
