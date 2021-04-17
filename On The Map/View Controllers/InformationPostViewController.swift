//
//  InformationPostViewController.swift
//  On The Map
//
//  Created by Kostas Lei on 07/04/2021.
//

import Foundation
import UIKit
import CoreLocation

class InformationPostViewController: UIViewController{
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cancelButton: UIButton!
    
    var placeHelper = CLLocationCoordinate2D()
    // GeoCoder instance
    let geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findLocationButton.layer.cornerRadius = 5
    }
    
    // FIND_LOCATION BUTTON: Checks if the geolocation exists and transfear the user
    // to locationVC, else
    @IBAction func findLocationButton(_ sender: Any) {
        activityIndicatorHandler(findLocation: true)
        geoCoder.geocodeAddressString(locationTextField.text!) { (placemark, error) in
            
            if error != nil{
                self.showGeoLocationFailure(message: error?.localizedDescription ?? "")
                self.activityIndicatorHandler(findLocation: false)
            }
            
            if let placemark = placemark?.first {
                print(placemark)
                self.activityIndicatorHandler(findLocation: false)
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                self.placeHelper = coordinates
                
                AppData.mapString = "\(placemark.locality!) \(placemark.administrativeArea!)"
                AppData.latitude = coordinates.latitude
                AppData.longtitude = coordinates.longitude
                AppData.mediaUrL = self.urlTextField.text!
                let vc = (self.storyboard?.instantiateViewController(identifier: "locationVC"))! as LocationViewController
                vc.modalPresentationStyle = .fullScreen
                vc.place = self.placeHelper
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    // CANCEL BUTTON: Dismisses the ViewController
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // SHOW_GEOLOCATION_FAILURE FUNC: Pops an alert message
    func showGeoLocationFailure(message: String) {
        let alertVC = UIAlertController(title: "Error finding this place", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // Handles the activityIndicator animation, buttons and textFields
    func activityIndicatorHandler(findLocation:Bool){
        if findLocation {
            activityIndicator.startAnimating()
        }
        else {
            activityIndicator.stopAnimating()
        }
        cancelButton.isEnabled = !findLocation
        locationTextField.isEnabled = !findLocation
        urlTextField.isEnabled = !findLocation
        findLocationButton.isEnabled = !findLocation
    }
}
