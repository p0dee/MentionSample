//
//  MessageViewController..swift
//  MentionSample
//
//  Created by p0dee on 2021/05/13.
//

import Combine
import UIKit

class MessageViewController: UIViewController {
    
    //MARK: - Properties
    private var messages: [Message] = []
    private var subscriptions: Set<AnyCancellable> = .init()

    //MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var fieldBaseBottomConstraint: NSLayoutConstraint!
    var presentingUserPicker: UserPickerView?
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setUpKeyboardWillShowNotification()
        textView.becomeFirstResponder()
    }
    
    private func setUpKeyboardWillShowNotification() {
        NotificationCenter.default.addObserver(forName: UIApplication.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
            let userInfo: NSDictionary = notification.userInfo! as NSDictionary
            let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.fieldBaseBottomConstraint.constant = keyboardHeight
        }
    }

    @IBAction func sendButtonDidTap(_ sender: Any) {
        let actualText = actualTextOfMessage(on: textView)
        guard actualText.count > 0 else { return }
        messages.append(.init(actualText: actualText))
        tableView.reloadData()
        textView.text = nil
    }
    
    private func actualTextOfMessage(on textView: UITextView) -> String {
        var attachments: [(range: NSRange, attachment: UserMentionTextAttachment)] = []
        let wholeRange = NSRange(location: 0, length: textView.attributedText.length)
        //textViewに含まれるすべてのIdentifierBasedTextAttachmentを探索し、その位置とattachmentをそれぞれ特定する
        textView.textStorage.enumerateAttribute(NSAttributedString.Key.attachment, in: wholeRange, options: []) { (any, range, stop) in
            if let attachment = any as? NSTextAttachment, let mentionAttachment = attachment as? UserMentionTextAttachment {
                attachments.append((range, mentionAttachment))
            }
        }
        //特定したすべてのIdentifierBasedTextAttachmentを、それぞれの実文字列(actualText)に置き換える
        let replaced = NSMutableAttributedString(attributedString: textView.attributedText)
        attachments.sorted(by: { $0.range.location > $1.range.location }).forEach { (range, attachment) in
            replaced.replaceCharacters(in: range, with: attachment.actualText)
        }
        return replaced.string
    }
    
}

//MARK: - UITableViewDataSource methods
extension MessageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MessageTableViewCell
        if indexPath.row < messages.count {
            cell.setContent(message: messages[indexPath.row])
        }
        return cell
    }
    
}

//MARK: - UITableViewDelegate methods
extension MessageViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "@" {
            presentUserPicker()
        } else {
            dismissPresentingUserPicker()
        }
        return true
    }
    
}
