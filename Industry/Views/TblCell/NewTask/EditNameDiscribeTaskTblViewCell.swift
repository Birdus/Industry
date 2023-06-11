//
//  EditNameDiscribeTaskTblViewCell.swift
//  Industry
//
//  Created by  Даниил on 22.05.2023.
//

import UIKit

protocol EditNameDiscribeTaskTblViewCellDelegate: AnyObject {
    /// This method is called when the text in the cell has changed.
        /// - Parameters:
        ///   - cell: The cell in which the text has changed.
        ///   - value: The new text value.
    func editNameDiscribeTaskTblViewCell(_ cell: EditNameDiscribeTaskTblViewCell, didChanged value: String)
}

class EditNameDiscribeTaskTblViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let indificatorCell = "EditNameDiscribeTaskTblViewCell"
    private var palcholder: String = String()
    weak var delegete: EditNameDiscribeTaskTblViewCellDelegate!
    // MARK: - Private UI
    private lazy var txtFld: UITextView = {
        let txt = UITextView()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.textColor = .black
        txt.textAlignment = .left
        txt.font = UIFont.systemFont(ofSize: CGFloat(UIScreen.main.bounds.width/10)/2)
        txt.delegate = self
        txt.backgroundColor = .clear
        return txt
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    /**
     Fills the table view cell with the given add task item palcholder and icon name.
     
     - Parameter palcholder: The palcholder of the add task item to display.
     - Parameter iconName: The name of the image to use as the add task item icon.
     */
    func fillTable(_ palcholder: String?, _ text: String?) {
        if let palcholder = palcholder {
            self.palcholder = palcholder
            txtFld.textColor = UIColor.lightGray
            txtFld.text = palcholder
        } else if let text = text {
            txtFld.text = text
            txtFld.textColor = .white
            self.palcholder = "Описание задачи".localized
        }
    }
    
    // MARK: - Private func
    private func configureUI() {
        self.contentView.addSubview(txtFld)
        NSLayoutConstraint.activate([
            txtFld.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            txtFld.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            txtFld.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            txtFld.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -5),
        ])
    }
}

// MARK: - UITextViewDelegate
extension EditNameDiscribeTaskTblViewCell: UITextViewDelegate {
    /// Called when the text view begins editing.
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.white
            }
        }

    /// Called when the text view ends editing.
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = palcholder
                textView.textColor = UIColor.lightGray
            } else {
                delegete.editNameDiscribeTaskTblViewCell(self, didChanged: textView.text)
            }
        }
    
    /// Asks the delegate whether the specified text should be replaced in the text view.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if(text == "\n") {
                textView.resignFirstResponder()
                return true
            }
            return true
        }
}

// MARK: - NewTaskViewControllerDelegate
extension EditNameDiscribeTaskTblViewCell: NewTaskViewControllerDelegate {
    func newTaskViewController(_ viewController: NewTaskViewController, didLoad values: [Employee], selected employees: [Employee]?) {
        return
    }
    
    func newTaskViewController(_ viewController: NewTaskViewController, isChande values: Bool) {
        return
    }
    
    func newTaskViewController(_ viewController: NewTaskViewController, didClosed: Bool) {
        if didClosed {
            delegete.editNameDiscribeTaskTblViewCell(self, didChanged: txtFld.text)
        }
    }
    
    func newTaskViewController(_ viewController: NewTaskViewController, didLoad values: [Employee]) {
        return
    }
    
    func newTaskViewController(_ viewController: NewTaskViewController, didLoad values: [Project]) {
        return
    }
}

