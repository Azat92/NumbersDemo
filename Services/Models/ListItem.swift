//
//  ListItem.swift
//  Services
//
//  Created by Azat Almeev on 07/07/2019.
//  Copyright © 2019 Azat Almeev. All rights reserved.
//

import Utils

/// Item that is being represented in Numbers module
public struct ListItem {

    public let section: Int
    public let value: Int
    public let isSelected: Bool
    
    public var sectionTitle: String {
        return "\(Localizations.Numbers.section)\(section + 1)"
    }
    
    public var displayValue: String {
        return "\(Localizations.Numbers.item)\(value + 1)"
    }
    
    init?(number: Int) {
        guard number >= 0 && number < 256 else { return nil } // Each number should be within the range 0...255 (1 Byte)
        section = number & 0b11 // The two least significant bits determine the "section index"
        value = number >> 2 & 0b11111 // The intermediate bits determine the "item value"
        isSelected = number >> 7 & 0b1 == 1 // The most significant bit determines the "item checkmark"
    }
}
