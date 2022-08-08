//
//  Int+Extension.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_207 on 16/06/2022.
//

import Foundation

extension Int {
    var isEven: Bool {
        return (self % 2) == 0
    }

    var isOdd: Bool {
        return (self % 2) == 1
    }

    var digits: [Int] {
        var result: [Int] = []
        for char in String(self) {
            let string = String(char)
            if let toInt = Int(string) {
                result.append(toInt)
            }
        }
        return result
    }

    var abs: Int {
        return Swift.abs(self)
    }

    func gcd(_ num: Int) -> Int {
        return num == 0 ? self : num.gcd(self % num)
    }

    func lcm(_ num: Int) -> Int {
        return (self * num).abs / gcd(num)
    }

    var factorial: Int {
        return self == 0 ? 1 : self * (self - 1).factorial
    }

    var degreesToRadians: Double {
        return Double(self) * .pi / 180
    }

    static func random(min: Int = 0, max: Int) -> Int {
        return Int.random(in: min..<max + 1)
    }

    var toString: String { return String(self) }

    var megabye: Int {
        return self * 1048576
    }
}
