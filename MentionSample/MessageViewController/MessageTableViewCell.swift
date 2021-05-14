//
//  MessageTableViewCell.swift
//  MentionSample
//
//  Created by p0dee on 2021/05/13.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    private var messageLabel: UILabel {
        return textLabel!
    }
    
    func setContent(message: Message) {
        messageLabel.attributedText = attributedMessageTextAppliedMentionRepresentation(for: message)
    }
    
    private func attributedMessageTextAppliedMentionRepresentation(for message: Message) -> NSAttributedString {
        let actualText = message.actualText
        var matches: [(range: NSRange, memberID: String)] = []
        UserMentionTextAttachmentContent.regularExpression.enumerateMatches(in: actualText, options: [], range: .init(location: 0, length: actualText.count)) { (result, flags, _) in
            if let result = result {
                let found = actualText.substring(range: result.range)
                let memberID = UserMentionTextAttachmentContent.trimFixedRegexPatterns(from: found)
                matches.append((result.range, memberID))
            }
        }
        
        let attributedString = NSMutableAttributedString(string: actualText)
        matches.reversed().forEach { (range, memberID) in
            let name: String
            if let member = UserRepository.shared.find(byID: memberID) {
                name = member.name
            } else {
                name = "--"
            }
            let attachment = UserMentionTextAttachment(content: .init(id: memberID, name: name, textAttributes: [.font : messageLabel.font!]))
            if let image = attachment.image {
                //align text and attachments vertically
                attachment.bounds = .init(origin: .init(x: 0, y: (messageLabel.font!.capHeight - image.size.height) / 2), size: image.size)
            }
            attributedString.replaceCharacters(in: range, with: .init(attachment: attachment))
        }
        return attributedString
    }
    
}
