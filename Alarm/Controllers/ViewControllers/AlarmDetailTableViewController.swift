//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by XMS_JZhan on 1/28/19.
//  Copyright © 2019 XMS_JZhan. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var enableButton: UIButton!
    
    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    var alarmIsOn: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let alarm = alarm else { return }
        self.alarmIsOn = alarm.enabled

    }

    @IBAction func enableButtonTapped(_ sender: UIButton) {
        if self.alarmIsOn {
            enableButton.backgroundColor = UIColor.red
            enableButton.setTitleColor(UIColor.white, for: .normal)
            enableButton.setTitle("Turn Off", for: .normal)
        } else {
            enableButton.backgroundColor = UIColor.white
            enableButton.setTitleColor(UIColor.red, for: .normal)
            enableButton.setTitle("Turn On", for: .normal)
        }
        guard let alarm = alarm else { return }
        alarmIsOn = !alarmIsOn
        AlarmController.shared.toggleEnabled(for: alarm)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = textField.text, name != "" else { return }
        guard let alarm = alarm else {
            AlarmController.shared.addAlarm(fireDate: datePicker.date, name: name, isOn: alarmIsOn)
            navigationController?.popViewController(animated: true)
            return
        }
        AlarmController.shared.update(alarm: alarm, fireDate: datePicker.date, name: name, enabled: alarmIsOn)
        navigationController?.popViewController(animated: true)
    }

    func updateViews() {
        guard let alarm = alarm else { return }
        datePicker.date = alarm.fireDate
        textField.text = alarm.name
        if alarm.enabled {
            enableButton.setTitle("Turn Off", for: .normal)
        } else {
            enableButton.setTitle("Turn On", for: .normal)
        }
    }
}
