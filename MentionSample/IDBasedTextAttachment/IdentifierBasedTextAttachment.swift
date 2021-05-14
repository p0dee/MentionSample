//
//  IdentifierBasedTextAttachment.swift
//  MentionSample
//
//  Created by p0dee on 2021/05/13.
//

import Foundation
import UIKit

///`IdentifierBasedTextAttachment`のコンテンツ
protocol IdentifierBasedTextAttachmentContent {
    
    /// ID文字列
    var id: String { get }
    
    /// 表示文字列
    var displayText: String { get }
    
    /// 表示文字の装飾属性
    var textAttributes: [NSAttributedString.Key : Any] { get }
    
    /// 表示文字列とは別の、ID文字列をもとに実文字列を生成するコールバック
    /// - 例: ユーザー「太郎」(ID: "abcd") に対するメンション表示
    ///    - `displayString`: `"@太郎"`
    ///    - `actualText`: `"#user:abcd#"`
    ///    - `actualTextProvider`: `{ content in return "#user:\(content.id)#"}`
    var actualTextProvider: (Self) -> String { get }
    
    /// attachmentとして表示する画像
    func attachmentImage() -> UIImage
        
}

extension IdentifierBasedTextAttachmentContent {
    
    /// 表示文字列とは別の、ID文字列を伴う実文字列
    var actualText: String {
        return actualTextProvider(self)
    }
    
}

/// ある単一の正規表現で表せるもの
protocol SigleRegularExpressible {
    
    /// クラスを共通して表す正規表現
    static var regularExpression: NSRegularExpression { get }
    
}

/// メンション表示(@XXX)のためのtext attachment。
class IdentifierBasedTextAttachment<Content>: NSTextAttachment where Content: IdentifierBasedTextAttachmentContent {
    
    private let content: Content
    
    var contentID: String {
        return content.id
    }
    
    /// 表示文字列
    var displayText: String {
        return content.displayText
    }
    
    /// 表示文字列のもととなる、ID文字列をもとに実文字列
    var actualText: String {
        return content.actualText
    }
    
    /// 表示内容をもとに初期化する
    /// - Parameter content: 表示内容
    init(content: Content) {
        self.content = content
        super.init(data: nil, ofType: nil)
        image = content.attachmentImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
