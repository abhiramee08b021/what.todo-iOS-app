//
//  ViewController.swift
//  what.todo
//
//  Created by abhiram moturi on 12/19/15.
//  Copyright © 2015 abhiram moturi. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: properties
    var tasks: [Task] = [Task]()
    var doneTasks: [Task] = [Task]()
    var showDoneItems = false
    
    //MARK: outlets
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addTaskTextField: UITextField!
    @IBOutlet weak var tasksTableView: UITableView!
    
    //MARK IBActions
    @IBAction func addButtonTapped(sender: AnyObject) {
        addTask()
        textFieldShouldReturn(addTaskTextField)
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        textFieldShouldReturn(addTaskTextField)
    }

    
    //MARK: methods
    func addTask(){
        if addTaskTextField.text == "" {
            // do nothing
        }
        else {
            let realm = try! Realm()
            let numTasks = realm.objects(Task).count
            let task = Task(label: addTaskTextField.text!, id: numTasks+1, due: NSDate(), notes: "")
            task.save()
            tasks.insert(task, atIndex: 0)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let realm = try! Realm()
        self.tasks = [Task]()
        self.doneTasks = [Task]()
        let tasks = realm.objects(Task).filter("isCompleted == false")
        let doneTasks = realm.objects(Task).filter("isCompleted == true")
        for task in tasks {
            self.tasks.insert(task, atIndex: 0)
        }
        for task in doneTasks {
            self.doneTasks.insert(task, atIndex: 0)
        }
        
        //UI modify
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Museo", size: 14)!]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.hidden = true
        cancelButton.hidden = true
        addTaskTextField.delegate = self
        tasksTableView.dataSource = self
        tasksTableView.delegate = self
        
        //UI related code
        tasksTableView.backgroundColor = UIColor.clearColor()
        tasksTableView.opaque = false
        tasksTableView.backgroundView = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDelegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tasks.count
        }
        else if section == 1 {
            if showDoneItems {
                return doneTasks.count
            }
            else {
                return 0
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Done Tasks"
        }
        return ""
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = UIView(frame: CGRectZero)
            headerView.frame = CGRectMake(0, 0, 200, 50)
            headerView.backgroundColor = UIColor(red: 0, green: 204/255, blue: 204/255, alpha: 1)
            
            let tap = UITapGestureRecognizer(target: self, action: Selector("doneItemsTapped:"))
            headerView.addGestureRecognizer(tap)
            
            let label = UILabel(frame: CGRectZero)
            label.textAlignment = NSTextAlignment(rawValue: 1)!
            label.font = UIFont(name: "Museo", size: 15)
            label.text = "\(doneTasks.count) Completed"
            label.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(label)
            label.backgroundColor = UIColor(red: 77/255, green: 182/255, blue: 173/255, alpha: 1)

            let width = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: headerView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
            let height = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: headerView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
            let top = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: headerView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            let leading = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: headerView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
            headerView.addConstraints([width, height, top, leading])
            
            
            return headerView
        }
        return UIView()
    }
    
    func doneItemsTapped(sender: UITapGestureRecognizer){
        print("done items tapped")
        if showDoneItems == true {
            showDoneItems = false
        }
        else {
            showDoneItems = true
        }
        tasksTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            doneTasks = []
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "TaskTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TaskTableViewCell
        let task: Task
        if indexPath.section == 0 {
            task = tasks[indexPath.row]
            cell.doneButton.tag = indexPath.row
            cell.doneButton.addTarget(self, action: Selector("doneButtonTapped:"), forControlEvents: .TouchUpInside)
        }
        else {
            task = doneTasks[indexPath.row]
        }
        cell.label.text = task.label
        cell.doneButton.enabled = !task.isCompleted
        cell.doneButton.setTitle("◉", forState: .Disabled)
        
        print("\(indexPath) \(cell.doneButton.enabled) \(task)")
        return cell
    }
    
    func doneButtonTapped(sender: UIButton){
        sender.setTitle("◉", forState: .Highlighted)
        let index = sender.tag
        let doneItem = tasks.removeAtIndex(index)
        doneItem.updateCompleted(true)
        doneTasks.insert(doneItem, atIndex: 0)
        print("\(doneTasks) \(tasks)")
        tasksTableView.reloadData()
    }
    
    //MARK: UITextFieldDelegate methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        addButton.hidden = true
        cancelButton.hidden = true
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.text = ""
        addButton.hidden = true
        cancelButton.hidden = true
        tasksTableView.reloadData()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        addButton.hidden = false
        cancelButton.hidden = false
    }
    
    //MARK: segue methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let taskDetailController = segue.destinationViewController as! EditTaskViewController
            if let selectedCell = sender as? TaskTableViewCell {
                let indexPath = tasksTableView.indexPathForCell(selectedCell)
                var selectedTask = Task()
                if indexPath?.section == 0 {
                    selectedTask = tasks[(indexPath?.row)!]
                }
                else if indexPath?.section == 1 {
                    selectedTask = doneTasks[(indexPath?.row)!]
                }
                taskDetailController.task = selectedTask
            }
        }
    }
    
    @IBAction func unWindToTaskList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.sourceViewController as? EditTaskViewController,
            task = sourceViewController.task {
                if let selectedIndex = tasksTableView.indexPathForSelectedRow {
                    task.save()
                    print("selectedIndex \(selectedIndex)")
                    if selectedIndex.section == 0 {
                        tasks[selectedIndex.row] = task
                    }
                    else {
                        doneTasks[selectedIndex.row] = task
                    }
                    tasksTableView.reloadRowsAtIndexPaths([selectedIndex], withRowAnimation: .Automatic)
                }
        }
    }


}

