//
//  UserPickerView.swift
//  MentionSample
//
//  Created by p0dee on 2021/05/13.
//

import UIKit

protocol UserPickerViewDelegate: class {
    
    func didSelectUser(pickerView: UserPickerView, user: User)
    
}

class UserPickerView: UIView {        
    
    @IBOutlet weak var tableView: UITableView!
    private var users: [User] = []
    
    weak var delegate: UserPickerViewDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpData()
    }
    
    private func setUpData() {
        users = UserRepository.shared.all()
    }
    
}

extension UserPickerView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.row < users.count {
            let user = users[indexPath.row]
            cell.textLabel?.text = user.name
        }
        return cell
    }
    
}

extension UserPickerView: UITableViewDelegate {    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < users.count else { return }
        let user = users[indexPath.row]
        delegate?.didSelectUser(pickerView: self, user: user)
    }
    
}
