//
//  NameTaskTblViewCell.swift
//  Industry
//
//  Created by  Даниил on 22.05.2023.
//

import UIKit

class NameTaskTblViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let indificatorCell = "NameTaskTblViewCell"
    private var palcholder: String = String()
    
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
    func fillTable(_ palcholder: String) {
        self.palcholder = palcholder
        txtFld.text = palcholder
        txtFld.textColor = UIColor.lightGray
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

extension NameTaskTblViewCell: UITextViewDelegate {
    // Метод делегата UITextView, вызывается при начале редактирования текста
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.white
            }
        }

        // Метод делегата UITextView, вызывается при окончании редактирования текста
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = palcholder
                textView.textColor = UIColor.lightGray
            }
        }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if(text == "\n") {
                textView.resignFirstResponder()
                return true
            }
            return true
        }
}

