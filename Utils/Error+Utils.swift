//
//  Error+Utils.swift
//  Utils
//
//  Created by Azat Almeev on 07/07/2019.
//  Copyright © 2019 Azat Almeev. All rights reserved.
//

extension NSError {
    
    convenience init(message: String) {
        self.init(domain: "ru.azatalmeev.NumbersDemo", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
