//
//  CGPoint+Extension.swift
//  TuruDebt
//
//  Created by Zai on 22/08/23.
//

import SwiftUI

extension CGFloat {
    public static func random() -> CGFloat {
        let randomValue: CGFloat = CGFloat(Float.random(in: 0..<100) / Float(0xFFFFFFFF))
        return randomValue
    }

    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random() * (max - min) + min
    }
}
