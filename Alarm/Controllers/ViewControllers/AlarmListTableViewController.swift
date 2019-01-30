//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by XMS_JZhan on 1/28/19.
//  Copyright © 2019 XMS_JZhan. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.shared.alarms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell else { return UITableViewCell() }
        cell.alarm = AlarmController.shared.alarms[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            AlarmController.shared.delete(alarm: AlarmController.shared.alarms[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // IIDOO
        if segue.identifier == "updateAlarmSegue" {
            if let destinationVC = segue.destination as? AlarmDetailTableViewController {
                guard let indexPath = tableView.indexPathForSelectedRow else { return }
                destinationVC.alarm = AlarmController.shared.alarms[indexPath.row]
            }
        }
    }
}

extension AlarmListTableViewController: SwitchTableViewCellDelegate {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        guard let alarm = cell.alarm, let indexPath = tableView.indexPath(for: cell) else { return }
        AlarmController.shared.toggleEnabled(for: alarm)
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        tableView.endUpdates()
    }
}
