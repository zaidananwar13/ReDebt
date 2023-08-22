//
//  CGFloat+Extension.swift
//  TuruDebt
//
//  Created by Zai on 22/08/23.
//

import SwiftUI

extension CGPoint {
    public func distance(from point: CGPoint) -> CGFloat {
        return hypot(point.x - self.x, point.y - self.y)
    }
}
