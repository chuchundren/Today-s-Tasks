//
//  AddViewController.swift
//  CoreData First Independent Try
//
//  Created by Дарья on 07/07/2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController {
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var previousVC: TableViewController!
    
    let dataManager = DataManager()
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var durationControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previousVC = TableViewController()
        
        textField.becomeFirstResponder()
        textField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(with:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(with:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        saveBtn.layer.cornerRadius = saveBtn.bounds.height / 2
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Keyboard
    
    @objc func keyboardWillShow(with notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardValue.cgRectValue.height

        if bottomConstraint.constant == 0 {
            bottomConstraint.constant -= keyboardHeight
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(with notification: Notification) {
        if bottomConstraint.constant != 0 {
            bottomConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        animateView(sender)
        guard textField.text != nil && textField.text != "" else { return }
        guard let taskToSave = textField.text else { return }
        
        dataManager.save(taskToSave, duration: durationControl.selectedSegmentIndex, managedContext: managedContext)
        //previousVC.tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func animateView(_ view: UIView) {
        UIView.animate(withDuration:0.15) {
            view.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        } completion: { (_) in
            UIView.animate(withDuration:0.1) {
                view.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
}

extension AddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
