//
//  UserMentionTextAttachment.swift
//  MentionSample
//
//  Created by p0dee on 2021/05/13.
//

import Foundation
import UIKit

//MARK: - UserMentionTextAttachment
class UserMentionTextAttachment: IdentifierBasedTextAttachment<UserMentionTextAttachmentContent> { }

//MARK: - UserMentionTextAttachmentContent
struct UserMentionTextAttachmentContent: IdentifierBasedTextAttachmentContent {
    
    var id: String
    
    var displayText: String
    
    var textAttributes: [NSAttributedString.Key : Any]
    
    var actualTextProvider: (UserMentionTextAttachmentContent) -> String
    
    init(id: String, name: String, textAttributes: [NSAttributedString.Key : Any] = [:]) {
        self.id = id
        self.displayText = "@\(name)"
        self.textAttributes = textAttributes
        self.actualTextProvider = { "#user:\($0.id)#" }
    }
    
    func attachmentImage() -> UIImage {
        return UIImage.userMentionLabel(name: displayText, textAttributes: textAttributes)
    }
    
}

extension UserMentionTextAttachmentContent: SigleRegularExpressible {
    
    /// 正規表現
    static var regularExpression: NSRegularExpression {
        return try! .init(pattern: "#user:[^#]*#", options: [])
    }
    
    /// `#user:xxx#` から、ID文字列部分(xxx)のみを抽出するs
    static func trimFixedRegexPatterns(from string: String) -> String {
        return string.substring(range: 6..<string.count - 1)
    }
    
}

//MARK: - UIImage
private extension UIImage {
    
    static func userMentionLabel(name: String, textAttributes: [NSAttributedString.Key : Any]) -> UIImage {
        let textBoundingRect = (name as NSString).boundingRect(with: .init(width: .max, height: .max), options: [.usesLineFragmentOrigin], attributes: textAttributes, context: nil)
        let paddingSize = CGSize(width: 4, height: 3)
        let imageRect: CGRect = {
            var rect = textBoundingRect
            rect.size.width += paddingSize.width * 2
            rect.size.height += paddingSize.height * 2
            return rect
        }()
        let textRect = imageRect.insetBy(dx: paddingSize.width, dy: paddingSize.height)
        let rrectRect = imageRect.insetBy(dx: 2, dy: 1)
        
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        UIColor(red: 0.93, green: 0.96, blue: 1.0, alpha: 1.0).setFill()
        UIColor(red: 0.46, green: 0.64, blue: 0.97, alpha: 1.0).setStroke()
        let path = UIBezierPath(roundedRect: rrectRect, cornerRadius: 2).cgPath
        ctx.addPath(path)
        ctx.setLineWidth(1 / UIScreen.main.scale)
        ctx.drawPath(using: .fillStroke)
        (name as NSString).draw(in: textRect, withAttributes: textAttributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
