//
//  EditHourTaskTblViewCell.swift
//  Industry
//
//  Created by  Даниил on 24.05.2023.
//

import UIKit

protocol EditHourTaskTblViewCellDelegate: AnyObject {
    /// This method is called when the hour in the cell has changed.
        /// - Parameters:
        ///   - cell: The cell in which the hour has changed.
        ///   - value: The new hour value.
    func editHourTaskTblViewCellTblViewCell(_ cell: EditHourTaskTblViewCell, didChanged value: Int)
}

class EditHourTaskTblViewCell: UITableViewCell {
    // MARK: - Properties
    static let indificatorCell = "EditHourTaskTblViewCell"
    weak var delegete: EditHourTaskTblViewCellDelegate!
    // MARK: - Private UI
    /// A UIView container image
    private lazy var containerIcon: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.masksToBounds = false
        return view
    }()
    
    /// A UIImageView  image user
    private lazy var imgIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var txtFld: UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.textColor = .white
        txt.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width / 10 / 2)
        txt.keyboardType = .numberPad
        txt.textAlignment = .left
        txt.delegate = self
        txt.addTarget(self, action: #selector(codeEntered), for: .editingChanged)
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
    
    // MARK: - Action
    @objc
    func codeEntered(_ textField: UITextField) {
        guard let code = textField.text else { return }
        switch code.count {
        case 8...Int.max:
            textField.deleteBackward()
        case 7:
            textField.resignFirstResponder()
        default:
            break
        }
    }
    
    // MARK: - Public Methods
    /**
     Fills the table view cell with the given add task item palcholder and icon name.
     
     - Parameter palcholder: The palcholder of the add task item to display.
     - Parameter iconName: The name of the image to use as the add task item icon.
     */
    func fillTable(placeholder: String?, hour: Int?, iconName: UIImage?) {
        setupPlaceholder(placeholder)
        setupDate(hour)
        imgIcon.image = iconName
    }
    
    // MARK: - Private func
    private func setupPlaceholder(_ text: String?) {
        guard let text = text else { return }
        let placeholderAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.lightGray]
        txtFld.attributedPlaceholder = NSAttributedString(string: text, attributes: placeholderAttributes)
        txtFld.placeholder = text
    }

    private func setupDate(_ hour: Int?) {
        guard let hour = hour else { return }
        txtFld.text = String(hour)
        let placeholder = "Колличество часов на задачу".localized
        setupPlaceholder(placeholder)
    }
    
    private func configureUI() {
        self.contentView.addSubview(containerIcon)
        self.contentView.addSubview(txtFld)
        containerIcon.addSubview(imgIcon)
        NSLayoutConstraint.activate([
            containerIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            containerIcon.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1),
            containerIcon.heightAnchor.constraint(equalTo: containerIcon.widthAnchor, multiplier: 1.0),
            containerIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            txtFld.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            txtFld.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            txtFld.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            txtFld.leadingAnchor.constraint(equalTo: imgIcon.trailingAnchor, constant: 10),
            txtFld.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            imgIcon.topAnchor.constraint(equalTo: containerIcon.topAnchor, constant: 5),
            imgIcon.leadingAnchor.constraint(equalTo: containerIcon.leadingAnchor, constant: 5),
            imgIcon.trailingAnchor.constraint(equalTo: containerIcon.trailingAnchor, constant: -5),
            imgIcon.bottomAnchor.constraint(equalTo: containerIcon.bottomAnchor, constant: -5),
        ])
    }
}

// MARK: - Text Field Delegate
extension EditHourTaskTblViewCell: UITextFieldDelegate {
    /// Called when the text field ends editing.
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let countHourString = txtFld.text, let countHour = Int(countHourString) {
            delegete.editHourTaskTblViewCellTblViewCell(self, didChanged: countHour)
        } else {
            txtFld.text = ""
        }
    }
    
    /// Asks the delegate if the text field should process the pressing of the return button.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFld {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}

// MARK: - Text Field Delegate
extension EditHourTaskTblViewCell: NewTaskViewControllerDelegate {
    func newTaskViewController(_ viewController: NewTaskViewController, didLoad values: [Employee], selected employees: [Employee]?) {
        return
    }
    
    func newTaskViewController(_ viewController: NewTaskViewController, isChande values: Bool) {
        return
    }
    
    func newTaskViewController(_ viewController: NewTaskViewController, didClosed: Bool) {
        if didClosed {
            if let countHourString = txtFld.text, let countHour = Int(countHourString) {
                delegete.editHourTaskTblViewCellTblViewCell(self, didChanged: countHour)
            }
        }
    }
    
    func newTaskViewController(_ viewController: NewTaskViewController, didLoad values: [Project]) {
        return
    }
}
