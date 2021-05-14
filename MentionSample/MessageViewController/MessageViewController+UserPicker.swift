//
//  MessageViewController+UserPicker.swift
//  MentionSample
//
//  Created by p0dee on 2021/05/13.
//

import UIKit

extension MessageViewController {
    
    func generatePickerView() -> UserPickerView {
        let nib = UINib(nibName: "UserPickerView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UserPickerView
        return view
    }
    
    func presentUserPicker() {
        let picker = generatePickerView()
        picker.delegate = self
        self.view.addSubview(picker)
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picker.centerXAnchor.constraint(equalTo: textView.centerXAnchor),
            picker.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: 10),
            picker.widthAnchor.constraint(equalToConstant: 250),
            picker.heightAnchor.constraint(equalToConstant: 120)
        ])
        presentingUserPicker = picker
    }
    
    func dismissPresentingUserPicker() {
        guard let picker = presentingUserPicker else { return }
        picker.removeFromSuperview()
    }
    
}

//MARK: - UserPickerViewDelegate methods
extension MessageViewController: UserPickerViewDelegate {
    
    func didSelectUser(pickerView: UserPickerView, user: User) {
        insertMention(for: user)
        dismissPresentingUserPicker()
    }
    
    func insertMention(for user: User) {
        //カーソル直前の文字(@であると決めうち)を消す
        self.textView.deleteBackward()
        guard let attributedText = textView.attributedText else { return }
        guard let selectedRange = self.textView.selectedTextRange else { return } //カーソル位置
        let initialCursorLocation = selectedRange.start //@表示挿入直前のカーソル位置
        //@表示を生成
        let attachment = UserMentionTextAttachment(content: .init(id: user.id, name: user.name))
        if let image = attachment.image {
            //上下方向が文字列と中央揃えになるよう位置合わせ
            attachment.bounds = .init(origin: .init(x: 0, y: (self.textView.font!.capHeight - image.size.height) / 2), size: image.size)
        }
        
        let mutable = NSMutableAttributedString(attributedString: attributedText)
        //@表示の挿入位置(オフセット数値)
        let insertionOffset = self.textView.offset(from: self.textView.beginningOfDocument, to: initialCursorLocation)
        mutable.insert(.init(attachment: attachment), at: insertionOffset)
        self.textView.attributedText = mutable
        //カーソル位置を@表示のうしろに設定する
        if let newCursorPosition = self.textView.position(from: initialCursorLocation, offset: 1) {
            self.textView.selectedTextRange = self.textView.textRange(from: newCursorPosition, to: newCursorPosition)
        }
    }
    
}
