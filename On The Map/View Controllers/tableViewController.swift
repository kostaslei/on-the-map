//
//  tableViewController.swift
//  On The Map
//
//  Created by Kostas Lei on 07/04/2021.
//

import Foundation
import UIKit

class TableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        
    }
    
    // REFRESH BUTTON: Calls the function that downloads the data for the last 100 users,
    // stores the values and reload them on the tableview
    @IBAction func refreshButton(_ sender: Any) {
        refreshHandle(reload: true)
        ParseAPI.getStudentInformation { (response, error) in
            if error == nil {
                AppData.parseDataResults = []
                AppData.parseDataResults = response
                self.refreshHandle(reload: false)
            }
            else{
                self.refreshHandle(reload: false)
                self.showFailure(message: error?.localizedDescription ?? "")
            }
        }
        tableView.reloadData()
    }
    
    // ADD BUTTON: Transfear us to the infoVC
    @IBAction func addButton(_ sender: Any) {
        let vc = (storyboard?.instantiateViewController(identifier: "infoVC"))! as UINavigationController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    // LOGOUT BUTTON: Logout the user and erase the data
    @IBAction func logoutButton(_ sender: Any) {
        UdacityAPI.logout{
            DispatchQueue.main.async{
                self.dismiss(animated: true, completion: nil)
            }}
    }
    
    // Handles the tableView alpha and buttons
    func refreshHandle(reload: Bool){
        tableView.alpha = reload ? 0.7 : 1
        addButton.isEnabled = !reload
        refreshButton.isEnabled = !reload
        logoutButton.isEnabled = !reload
    }
    
    func showFailure(message: String) {
        let alertVC = UIAlertController(title: "Failed downloading data", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
}

// EXTENSION: Controls the table functionality
extension TableViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // The number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return AppData.parseDataResults.count
    }
    
    // Set the text of the text labels in every cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as! tableViewCell
        
        let results = AppData.parseDataResults[indexPath.row]
        
        cell.mainTextLabel.text = results.firstName + " " + results.lastName
        cell.mainTextLabel.font = .systemFont(ofSize: 20)
        cell.descriptionTextLabel.text = results.mediaURL
        cell.descriptionTextLabel.font = .systemFont(ofSize: 18)
        cell.imageView?.image = UIImage(named: "icon_image")
        return cell
    }
    
    // Action when a cell is clicked it opens a link in safari
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open((URL(string: AppData.parseDataResults[indexPath.row].mediaURL)  ?? URL(string: "https://www.google.com"))!, options: [:], completionHandler: nil)
    }
}
