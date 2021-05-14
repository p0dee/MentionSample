//
//  String+Extension.swift
//  MentionSample
//
//  Created by p0dee on 2021/05/13.
//

import Foundation

extension String {

    func substring(range: Range<Int>) -> String {
        return String(self[index(self.startIndex, offsetBy: range.lowerBound)..<index(startIndex, offsetBy: range.upperBound)])
    }
    
    func substring(range: NSRange) -> String {
        return String(self[index(startIndex, offsetBy: range.location)..<index(startIndex, offsetBy: range.location + range.length)])
    }
    
}
