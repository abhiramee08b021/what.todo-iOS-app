//
//  EditTaskViewController.swift
//  what.todo
//
//  Created by abhiram moturi on 12/19/15.
//  Copyright © 2015 abhiram moturi. All rights reserved.
//

import UIKit

class EditTaskViewController: UIViewController, UITextViewDelegate {
    
    //MARK properties
    var task: Task?
    var activeField: UITextInput? = nil
    let placeholderText = "notes..."
    
    //MARK IBOutlets
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var editTaskLabelTextField: UITextField!
    @IBOutlet weak var editTaskNotesTextView: UITextView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    
    //Mark IBActions
    @IBAction func cancelTapped() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK methods
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        print("\(touch?.view)")
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        editTaskNotesTextView.delegate = self
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("contentViewTapped:")))
    }
    
    func contentViewTapped(sender: UITapGestureRecognizer){
        if sender.view == contentView {
            contentView.endEditing(true)
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        activeField = textView as UITextInput
        if textView.text == "notes..." {
           textView.text = ""
        }
        textView.alpha = 0.5
        textView.becomeFirstResponder()
        // Scroll the UIScrollView up
        scrollView.setContentOffset(CGPoint(x:0, y: textView.frame.origin.y + 30), animated: true)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        activeField = nil
        if textView.text == "" {
            textView.text = placeholderText
            textView.alpha = 0.2
        }
        textView.resignFirstResponder()
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    override func viewDidLoad() {
        editTaskLabelTextField.text = task?.label
        editTaskNotesTextView.text = task?.notes
        if editTaskNotesTextView.text == "" {
            editTaskNotesTextView.text = placeholderText
            editTaskNotesTextView.alpha = 0.2
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if editTaskNotesTextView.text == placeholderText {
            editTaskNotesTextView.text = ""
        }
        let isCompleted = task?.isCompleted
        task = Task(label: editTaskLabelTextField.text!, id: (task?.id)!, due: (task?.due)!, notes: editTaskNotesTextView.text)
        task!.save()
        task!.updateCompleted(isCompleted!)
    }
    
    //MARK scroll view methods

}
