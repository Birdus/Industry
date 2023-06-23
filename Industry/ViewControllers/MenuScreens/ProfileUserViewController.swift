// ProfileUserViewController.swift
// Industry
//
// Created by Danil Getmantsev on 14.03.2023.
//

import UIKit
import AVFoundation

/// Protocol for the ProfileUserViewController delegate.
protocol ProfileUserViewControllerDelegate: AnyObject {
    /// Called when the ProfileUserViewController loads an employee image.
    func profileUserViewController(_ viewController: ProfileUserViewController, didLoadEmployee imageUser: @escaping (UIImage)-> Void)
    
    /// Called when the ProfileUserViewController exports an employee image.
    func profileUserViewController(_ viewController: ProfileUserViewController, didExportEmployee imageUser: UIImage)
}

/**
 ProfileUserViewController displays a user's profile with a menu of options.
 */
class ProfileUserViewController: UIViewController {
    // MARK: - Properties
    /// The delegate for the ProfileUserViewController.
    weak var delegete: ProfileUserViewControllerDelegate!
    
    /// The `Employee` object associated with the ProfileUserViewController.
    private var employee: Employee!
    
    /// The `AVCaptureSession` object used for scanning QR codes.
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var overlayView: UIView?
    // MARK: - Private UI
    /// A table view that displays menu items.
    private lazy var tblMenu: UITableView = {
        let tableView = UITableView()
        tableView.register(HeadMenuTblViewCell.self, forCellReuseIdentifier: HeadMenuTblViewCell.indificatorCell)
        tableView.register(UserCountTaskTblViewCell.self, forCellReuseIdentifier: UserCountTaskTblViewCell.indificatorCell)
        tableView.register(MenuItemTblViewCell.self, forCellReuseIdentifier: MenuItemTblViewCell.indificatorCell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.accessibilityIdentifier = "tblMenu"
        return tableView
    }()
    
    /// An image for the user.
    private lazy var imgChange: UIImage = {
        let imageView = UIImage(named: "userAvatar") ?? UIImage()
        imageView.accessibilityIdentifier = "imgChange"
        return imageView
    }()
    
    /// A gesture recognizer for swipe right gestures.
    private lazy var swipeRightScaner: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipe.direction = .right
        return swipe
    }()
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        view.backgroundColor = .white
    }
    
    deinit {
        self.view.removeGestureRecognizer(swipeRightScaner)
        print("sucsses closed ProfileUserViewController")
    }
    // MARK: - Action
    /// Responds to swipe gestures.
    ///
    /// This method is called in response to a swipe gesture. If the swipe is to the right, it stops the capture session and dismisses the view controller.
    ///
    /// - Parameter gesture: The UIGestureRecognizer instance that is calling this method.
    @objc
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                self.captureSession?.stopRunning()
                self.dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
    }

    @objc
    func exitButton_Tapped(_ sender: UIButton) {
        closeCamera()
    }
    // MARK: - Private Methods
    private func closeCamera() {
        self.captureSession?.stopRunning()
        self.previewLayer?.removeFromSuperlayer()
        self.overlayView?.removeFromSuperview()
        
        self.previewLayer = nil
        self.overlayView = nil
    }
    
    private func startScanningQRCode() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] response in
            guard let self = self else { return }
            
            if response {
                DispatchQueue.main.async {
                    self.setupCaptureSession()
                }
            } else {
                self.showAlController(messege: "Доступ к камере запрещен")
            }
        }
    }

    private func setupCaptureSession() {
            captureSession = AVCaptureSession()

            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
                self.showAlController(messege: "Не удалось получить доступ к камере")
                return
            }

            do {
                let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
                if captureSession!.canAddInput(videoInput) {
                    captureSession!.addInput(videoInput)
                } else {
                    self.showAlController(messege: "Не удалось добавить входное устройство видеозахвата")
                    return
                }

                let metadataOutput = AVCaptureMetadataOutput()
                if captureSession!.canAddOutput(metadataOutput) {
                    captureSession!.addOutput(metadataOutput)
                    metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    metadataOutput.metadataObjectTypes = [.qr]
                } else {
                    self.showAlController(messege: "Не удалось добавить выходное устройство видеозахвата")
                    return
                }

                self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                previewLayer!.frame = view.layer.bounds
                previewLayer!.videoGravity = .resizeAspectFill
                self.view.layer.addSublayer(previewLayer!)

                captureSession!.startRunning()

                self.overlayView = UIView(frame: view.bounds)
                self.view.addSubview(overlayView!)
                overlayView!.addGestureRecognizer(swipeRightScaner)

                // Add exit button
                let exitButton = UIButton()
                guard let overlayView = overlayView else {
                    return
                }
                exitButton.setTitle("Exit", for: .normal)
                exitButton.translatesAutoresizingMaskIntoConstraints = false
                exitButton.titleLabel?.textColor = .blue
                overlayView.addSubview(exitButton)
                exitButton.addTarget(self, action: #selector(exitButton_Tapped), for: .touchUpInside)

                NSLayoutConstraint.activate([
                    exitButton.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 20),
                    exitButton.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 20),
                    exitButton.widthAnchor.constraint(equalToConstant: 60),
                    exitButton.heightAnchor.constraint(equalToConstant: 60)
                ])

            } catch {
                self.showAlController(messege: "Ошибка при инициализации устройства видеозахвата")
            }
        }

        
    /// This fumc show alelrt controoler
    ///
    /// - Parameter messege: The messege show alert controller
    private func showAlController(messege: String) {
        let alControl:UIAlertController = {
            let alControl = UIAlertController(title: "Ошибка".localized, message: messege, preferredStyle: .alert)
            let btnOk: UIAlertAction = {
                let btn = UIAlertAction(title: "Ok".localized,
                                        style: .default,
                                        handler: nil )
                return btn
            }()
            alControl.addAction(btnOk)
            return alControl
        }()
        self.present(alControl, animated: true, completion: nil)
    }
    
    /// This fumc show alelrt controoler
    ///
    /// - Parameter messege: The messege show alert controller
    private func showAlController(messege: String, title: String) {
        let alControl:UIAlertController = {
            let alControl = UIAlertController(title: title, message: messege, preferredStyle: .alert)
            let btnOk: UIAlertAction = {
                let btn = UIAlertAction(title: "Ok".localized,
                                        style: .default,
                                        handler: nil )
                return btn
            }()
            alControl.addAction(btnOk)
            return alControl
        }()
        self.present(alControl, animated: true, completion: nil)
    }

    /// Configures the view controller's UI.
    private func configureUI() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        view.addSubview(tblMenu)
        NSLayoutConstraint.activate([
            tblMenu.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tblMenu.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tblMenu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tblMenu.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - UITableViewDelegate
extension ProfileUserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.size.height
        let contentOffsetY = tableView.contentOffset.y
        switch indexPath.row {
        case 0:
            return ((screenHeight / 2 + contentOffsetY) / 2) / 1.5
        case 1:
            return ((screenHeight / 2 + contentOffsetY) / 2) / 2
        default:
            return ((screenHeight / 2 + contentOffsetY) / 2) / 2.5
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc: UIViewController = UIViewController()
        switch indexPath.row {
        case 2:
            vc = NotificationListViewController()
            let vcNav = UINavigationController(rootViewController: vc)
            vcNav.modalPresentationStyle = .fullScreen
            navigationController?.present(vcNav, animated: true, completion: nil)
        case 3:
            vc = StatisticUserViewController()
            let vcNav = UINavigationController(rootViewController: vc)
            vcNav.modalPresentationStyle = .fullScreen
            navigationController?.present(vcNav, animated: true, completion: nil)
        case 4:
            vc = SettingUserViewController()
            let vcNav = UINavigationController(rootViewController: vc)
            vcNav.modalPresentationStyle = .fullScreen
            navigationController?.present(vcNav, animated: true, completion: nil)
        case 5:
            setupCaptureSession()
        case 6:
            let alControl: UIAlertController = {
                let alControl = UIAlertController(title: "Выход".localized, message: "Вы хотите выйти из акаунта?".localized, preferredStyle: .alert)
                let btnOk: UIAlertAction = {
                    let btn = UIAlertAction(title: "Ok".localized, style: .default) { _ in
                        let apiManager = APIManagerIndustry()
                        apiManager.dropTokens()
                        apiManager.dropAuthBody()
                        let vc = EnterMenuViewController()
                        let navVc = UINavigationController(rootViewController: vc)
                        self.view.removeGestureRecognizer(self.swipeRightScaner)
                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                            appDelegate.window?.rootViewController = navVc
                        }
                    }
                    return btn
                }()
                let btnCancel: UIAlertAction = {
                    let btn = UIAlertAction(title: "Отмена".localized, style: .default, handler: nil)
                    return btn
                }()
                alControl.addAction(btnOk)
                alControl.addAction(btnCancel)
                return alControl
            }()
            self.present(alControl, animated: true, completion: nil)
        default:
            return
        }
    }
}

// MARK: - UITableViewDataSource
extension ProfileUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HeadMenuTblViewCell.indificatorCell, for: indexPath) as? HeadMenuTblViewCell else {
                fatalError("Unable to dequeue HeadMenuTableViewCell.")
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            
            cell.fiillTable("\(employee.lastName) \(employee.firstName) \(employee.secondName)", employee.division.divisionName, employee.role, imgChange)
            cell.separatorInset = UIEdgeInsets(top: 0, left: view.bounds.width / 4, bottom: 0, right: 0)
            cell.delegete = self
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCountTaskTblViewCell.indificatorCell, for: indexPath) as? UserCountTaskTblViewCell else {
                fatalError("Unable to dequeue UserCountTaskTableViewCell.")
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            if let laborCost = employee.laborCosts {
                var sumHour: Int = 0
                laborCost.forEach { sumHour += $0.hourCount }
                cell.fiillTable(laborCost.count, sumHour)
            } else {
                cell.fiillTable(0, 0)
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemTblViewCell.indificatorCell, for: indexPath) as? MenuItemTblViewCell else {
                fatalError("Unable to dequeue MenuItemTableViewCell.")
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.accessoryType = .disclosureIndicator
            cell.contentView.backgroundColor = .clear
            switch indexPath.row {
            case 2:
                cell.fiillTable("Уведомления".localized, UIImage(named: "iconNotification"))
            case 3:
                cell.fiillTable("Статистика".localized, UIImage(named: "iconStatistic"))
            case 4:
                cell.fiillTable("Настройки".localized, UIImage(named: "iconSetting"))
            case 5:
                cell.fiillTable("QR-сканер".localized, UIImage(named: "iconQrScaner"))
            case 6:
                cell.fiillTable("Выйти".localized, UIImage(named: "iconExit"))
            default:
                cell.fiillTable("", UIImage())
            }
            return cell
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ProfileUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// Called when an image is picked from the image picker.
    /// - Parameters:
    ///   - picker: The UIImagePickerController instance that is calling this delegate method.
    ///   - info: A dictionary containing the original image and the edited image, if an image was picked.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            delegete.profileUserViewController(self, didExportEmployee: image)
            imgChange = image
            tblMenu.reloadData()
            dismiss(animated: true)
        } else {
            picker.dismiss(animated: true, completion: nil)
            let alControl: UIAlertController = {
                let alControl = UIAlertController(title: "Ошибка".localized, message: "Фотография не найденна".localized, preferredStyle: .alert)
                let btnOk: UIAlertAction = {
                    let btn = UIAlertAction(title: "Ok".localized, style: .default, handler: nil)
                    return btn
                }()
                alControl.addAction(btnOk)
                return alControl
            }()
            present(alControl, animated: true, completion: nil)
        }
    }
    
    /// Called when the image picker is cancelled.
    /// - Parameter picker: The UIImagePickerController instance that is calling this delegate method.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ProfileUserViewController: AVCaptureMetadataOutputObjectsDelegate {
    /// Called when the metadata output has outputted metadata objects.
    /// - Parameters:
    ///   - output: The AVCaptureMetadataOutput instance that is calling this delegate method.
    ///   - metadataObjects: An array of AVMetadataObject instances representing the metadata that was recognized in the input.
    ///   - connection: The AVCaptureConnection instance that is calling this delegate method.
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first,
           let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
           let stringValue = readableObject.stringValue {
            self.showAlController(messege: stringValue, title: "Ваш отсканированный QR")
            captureSession?.stopRunning()
            closeCamera()
        }
    }
}

// MARK: - TabBarControllerDelegate
extension ProfileUserViewController: TabBarControllerDelegate {
    /// Called when a tab is selected in the TabBarController.
    /// - Parameters:
    ///   - tabBarController: The TabBarController instance that is calling this delegate method.
    ///   - index: The index of the selected tab.
    ///   - datas: An array of Issues instances representing the issues associated with the selected tab.
    ///   - data: An Employee instance representing the employee associated with the selected tab.
    func tabBarController(_ tabBarController: TabBarController, didSelectTabAtIndex index: Int, issues datas: [Issues], employee data: Employee) {
        self.employee = data
        delegete.profileUserViewController(self, didLoadEmployee: {image in
            self.imgChange = image
        })
        return
    }
}

// MARK: - HeadMenuTblViewCellDelegate
extension ProfileUserViewController: HeadMenuTblViewCellDelegate {
    /// Called when an image is picked from the HeadMenuTblViewCell.
    /// - Parameters:
    ///   - cell: The HeadMenuTblViewCell instance that is calling this delegate method.
    ///   - avatar: The UIImageView instance representing the picked image.
    func headMenuTblViewCell(_ cell: HeadMenuTblViewCell, didFinishPickingImage avatar: UIImageView) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.allowsEditing = false
        self.present(picker, animated: true)
    }
}
