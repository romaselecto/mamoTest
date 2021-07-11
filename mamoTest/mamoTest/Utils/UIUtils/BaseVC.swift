//
//  BaseVC.swift
//  mamoTest
//
//  Created by Roma Osiychuk on 09.07.2021.
//

import Foundation
import NVActivityIndicatorView
import SafariServices
import UIKit

class BaseVC: UIViewController, NVActivityIndicatorViewable {
    // MARK: - IBOutlets

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!

    // MARK: - Private Variables

    private var bgndTapGestureRecognizer: UITapGestureRecognizer?

    // MARK: - Public Variables

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var onDissmissCompletion: void_block?
    var statusBarShouldBeHidden = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        listenNotifications()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeBgndTapGestureRecognizer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeBgndTapGestureRecognizer()
        view.endEditing(true)
    }

    deinit {
        removeNotifications()
    }

    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    // MARK: - Activity Indicator Methods

    func startIndicator() {
        startAnimating(type: .circleStrokeSpin, color: UIColor.black, backgroundColor: .clear)
    }

    func stopIndicator() {
        stopAnimating()
    }

    // MARK: - Notification Methods

    func listenNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func removeNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - IBActions

    @IBAction func onBtnBack(_: Any? = nil) {
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: onDissmissCompletion)
        }
    }

    @IBAction func onBtnNotImplementedPressed(_: Any) {
        Utils.standartAlertMessage(message: "Not implemented yet", title: "Coming soon") {}
    }

    // MARK: - NSNotifications

    @objc func keyboardWillHide(notification _: NSNotification) {
        // override in child class
    }

    @objc func keyboardWillShow(notification _: NSNotification) {
        // override in child class
    }

    // MARK: - Open URL Handler

    func openBrowser(_ url: String) {
        guard let url = URL(string: url) else {
            return
        }
        if ["http", "https"].contains(url.scheme?.lowercased() ?? "") {
            let browser = SFSafariViewController(url: url)
            present(browser, animated: true, completion: nil)
        } else {
            Utils.standartAlertMessage(message: "Invalid URL", title: "Error") {}
        }
    }
}

extension BaseVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.isSecureTextEntry {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)

            if range.location > 0, range.length == 1, string.count == 0 {
                // iOS is trying to delete the entire string
                textField.text = newString
                return false
            }

            // prevent typing clearing the pass
            if range.location == textField.text?.count {
                textField.text = newString
                return false
            }
        }

        return true
    }
}

// MARK: - UIGestureRecognizerDelegate

extension BaseVC: UIGestureRecognizerDelegate {}

// MARK: - HandleTapGesture

extension BaseVC {
    @objc func initializeBgndTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBgndTap(aRecognizer:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        bgndTapGestureRecognizer = tapGesture
    }

    func removeBgndTapGestureRecognizer() {
        if let tapGesture = bgndTapGestureRecognizer {
            view.removeGestureRecognizer(tapGesture)
        }
    }

    @objc func handleBgndTap(aRecognizer: UITapGestureRecognizer) {
        let rView = aRecognizer.view
        let location = aRecognizer.location(in: rView)
        let viewOfTouch = rView?.hitTest(location, with: nil)

        if !(viewOfTouch is UIButton) {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.view.endEditing(true)
            }
        }

        print("Handle tap in: \(self)")
    }
}
