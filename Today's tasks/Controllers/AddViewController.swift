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
    
    let dataManager = DataManager()
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
            textField.becomeFirstResponder()
        }
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var durationControl: UISegmentedControl!
    @IBOutlet weak var listPickerView: UIPickerView! {
        didSet {
            listPickerView.delegate = self
            listPickerView.dataSource = self
        }
    }
    @IBOutlet weak var expandPickerButton: UIButton!
    
    @IBOutlet weak var descriptionTextField: UITextField! {
        didSet {
            descriptionTextField.delegate = self
        }
    }
    
    var isPickerExpanded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(with:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(with:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        saveBtn.layer.cornerRadius = saveBtn.bounds.height / 2
        
        configureTapGesture()
        
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    private func togglePicker() {
        if listPickerView.isHidden {
            listPickerView.isHidden = false
        } else {
            listPickerView.isHidden = true
        }
    }
    
    private func animateSafeButtonToggle(_ view: UIView) {
        UIView.animate(withDuration:0.15) {
            view.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        } completion: { (_) in
            UIView.animate(withDuration:0.1) {
                view.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        animateSafeButtonToggle(sender)
        guard textField.text != nil && textField.text != "" else { return }
        guard let taskToSave = textField.text else { return }
        
        let task = Task(context: managedContext)
        task.title = taskToSave
        task.duration = Int16(durationControl.selectedSegmentIndex)
        task.isCompleted = false
        task.creationDate = Date()
        task.taskDescription = descriptionTextField.text
        task.list = ListsData.lists[listPickerView.selectedRow(inComponent: 0)]
        
        do {
            try managedContext.save()
            
            print("success!! task is saved: \(task.title!), \(task.list!.title)")
        
        } catch let error as NSError {
            print("could not save. \(error), \(error.userInfo)")
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showListsPickerViewTapped(_ sender: Any) {
        view.endEditing(true)
        togglePicker()
    }
    
    //MARK: - Keyboard
    
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
    
}

extension AddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        listPickerView.isHidden = true
    }
}

extension AddViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ListsData.lists.count
    }
    
}

extension AddViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let list = ListsData.lists[row]
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: list.color) ?? .systemBlue
        ]
        return NSAttributedString(string: list.title, attributes: attributes)
    }
}
