//
//  EditDateTaskTblViewCell.swift
//  Industry
//
//  Created by  Даниил on 23.05.2023.
//

import UIKit

protocol EditDateTblViewCellDelegate: AnyObject {
    /// This method is called when the date in the cell has changed.
       /// - Parameters:
       ///   - cell: The cell in which the date has changed.
       ///   - value: The new date value.
    func editDateTblViewCell(_ cell: EditDateTaskTblViewCell, didChanged value: Date)
}

class EditDateTaskTblViewCell: UITableViewCell {
    // MARK: - Properties
    static let indificatorCell = "EditDateTaskTblViewCell"
    weak var delegete: EditDateTblViewCellDelegate!
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
    
    private lazy var picDateTime: UIDatePicker = {
        let picDate = UIDatePicker()
        picDate.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.4, *) {
            picDate.preferredDatePickerStyle = .wheels
        }
        picDate.minimumDate = Date()
        picDate.datePickerMode = .date
        return picDate
    }()
    
    /// A UIImageView  image user
    private lazy var imgIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var tlBarDatePic: UIToolbar = {
        let tlBar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 44.0)))
        let doneButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(btnDone_Click))
        let cancelButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(btnCancel_click))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        tlBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        tlBar.isUserInteractionEnabled = true
        tlBar.sizeToFit()
        tlBar.translatesAutoresizingMaskIntoConstraints = false
        return tlBar
    }()
    
    private lazy var txtFld: UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.textColor = .white
        txt.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width / 10 / 2)
        txt.textAlignment = .left
        txt.textAlignment = .left
        txt.delegate = self
        txt.inputView = picDateTime
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
    private func btnDone_Click(_ sender: UIBarButtonItem) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.yyyy"
        txtFld.text = dateFormater.string(from: picDateTime.date)
        txtFld.resignFirstResponder()
    }
    
    @objc
    private func btnCancel_click(_ sender: UIBarButtonItem) {
        txtFld.resignFirstResponder()
    }
    
    // MARK: - Public Methods
    /**
     Fills the table view cell with the given add task item palcholder and icon name.
     
     - Parameter palcholder: The palcholder of the add task item to display.
     - Parameter iconName: The name of the image to use as the add task item icon.
     */
    func fillTable(placeholder: String?, date: Date?, iconName: UIImage?) {
        setupPlaceholder(placeholder)
        setupDate(date)
        imgIcon.image = iconName
    }
    
    // MARK: - Private func
    
    private func setupPlaceholder(_ text: String?) {
        guard let text = text else { return }
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.lightGray]
        txtFld.attributedPlaceholder = NSAttributedString(string: text, attributes: placeholderAttributes)
        txtFld.placeholder = text
    }

    private func setupDate(_ date: Date?) {
        guard let date = date else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        txtFld.text = dateFormatter.string(from: date)
        
        let placeholder = "Дата окончание задачи".localized
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
extension EditDateTaskTblViewCell: UITextFieldDelegate {
    /// Called when the text field begins editing.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtFld {
            txtFld.inputAccessoryView = tlBarDatePic
        }
    }
    
    /// Called when the text field ends editing.
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtFld {
            txtFld.inputAccessoryView = nil
            delegete.editDateTblViewCell(self, didChanged: picDateTime.date)
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

// MARK: - NewTaskViewControllerDelegate
extension EditDateTaskTblViewCell: NewTaskViewControllerDelegate {
    func newTaskViewController(_ viewController: NewTaskViewController, didLoad values: [Employee], selected employees: [Employee]?) {
        return
    }
    
    func newTaskViewController(_ viewController: NewTaskViewController, isChande values: Bool) {
        return
    }
    
    func newTaskViewController(_ viewController: NewTaskViewController, didClosed: Bool) {
        if didClosed {
            delegete.editDateTblViewCell(self, didChanged: picDateTime.date)
        }
    }
    
    func newTaskViewController(_ viewController: NewTaskViewController, didLoad values: [Project]) {
        return
    }
}
