//
// PrivacyPolicyViewController.swift
// Industry
//
// Created by Даниил on 10.05.2023.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {
    
    // MARK: - Ui
    private lazy var btnBack: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Назад".localized, style: .plain, target: self, action: #selector(btnBack_Click))
        return btn
    }()
    
    private lazy var scrllPolicy: UIScrollView = {
        let scrll = UIScrollView()
        scrll.backgroundColor = .white
        scrll.frame = view.bounds
        scrll.contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height + 600)
        scrll.translatesAutoresizingMaskIntoConstraints = false
        return scrll
    }()
    
    private lazy var scrllCont: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: CGFloat(UIScreen.main.bounds.width / 10) / 2.3)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.layer.masksToBounds = true
        lbl.numberOfLines = 0
        lbl.text = """
            Политика конфиденциальности для мобильного приложения Industry:
            1. Общие положения
            1.1. Данная политика конфиденциальности определяет порядок использования персональной информации, которую может собирать мобильное приложение Industry (далее - "Приложение").
            1.2. В рамках данной Политики под персональной информацией понимается любая информация, которая относится к определенному или определяемому физическому лицу (пользователю Приложения) и которая может быть использована для его идентификации.
            1.3. Приложение используется исключительно внутри компании, и персональная информация, собранная в процессе использования Приложения, используется только в рамках деятельности компании и не передается третьим лицам.
            2. Сбор и использование персональной информации
            2.1. Приложение может собирать следующую персональную информацию пользователей:
            * Имя и фамилия;
            * Должность;
            * E-mail;
            * Номер телефона.
            2.2. Собранная информация используется исключительно в целях обеспечения работы Приложения, а также для связи с пользователем при необходимости.
            2.3. Приложение не передает собранную персональную информацию третьим лицам и не использует ее для маркетинговых целей.
            3. Хранение и защита персональной информации
            3.1. Приложение сохраняет персональную информацию пользователей на серверах внутри компании.
            3.2. Приложение обеспечивает надежную защиту персональной информации пользователей от несанкционированного доступа, изменения, распространения или уничтожения.
            4. Изменения политики конфиденциальности
            4.1. Политика конфиденциальности может быть изменена при необходимости.
            4.2. В случае изменения Политики конфиденциальности, пользователи будут проинформированы об этом в рамках использования Приложения.
            5. Контакты
            5.1. В случае возникновения вопросов по Политике конфиденциальности или по обработке персональной информации пользователей Приложения, пользователи могут обратиться к администрации компании, используя контактные данные, указанные в Приложении.
            """.localized
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        return lbl
    }()
    
    private lazy var viewDescription: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Action
    @objc
    private func btnBack_Click(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        self.navigationItem.leftBarButtonItem = btnBack
        view.addSubview(scrllPolicy)
        scrllPolicy.addSubview(scrllCont)
        scrllCont.addArrangedSubview(viewDescription)
        viewDescription.addSubview(lblDescription)
        NSLayoutConstraint.activate([
            scrllPolicy.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrllPolicy.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrllPolicy.topAnchor.constraint(equalTo: view.topAnchor),
            scrllPolicy.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrllCont.leadingAnchor.constraint(equalTo: scrllPolicy.leadingAnchor),
            scrllCont.trailingAnchor.constraint(equalTo: scrllPolicy.trailingAnchor),
            scrllCont.topAnchor.constraint(equalTo: scrllPolicy.topAnchor),
            scrllCont.bottomAnchor.constraint(equalTo: scrllPolicy.bottomAnchor),
            scrllCont.widthAnchor.constraint(equalTo: scrllPolicy.widthAnchor),
            
            lblDescription.leadingAnchor.constraint(equalTo: viewDescription.leadingAnchor, constant: 10),
            lblDescription.trailingAnchor.constraint(equalTo: viewDescription.trailingAnchor, constant: -10),
            lblDescription.topAnchor.constraint(equalTo: viewDescription.topAnchor, constant: 5),
            lblDescription.bottomAnchor.constraint(equalTo: viewDescription.bottomAnchor),
        ])
        // Resize the redView to fit its contents
        let redViewSize = viewDescription.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        viewDescription.frame.size = redViewSize
    }
}
