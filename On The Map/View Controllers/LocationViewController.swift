//
//  LocationViewController.swift
//  On The Map
//
//  Created by Kostas Lei on 07/04/2021.
//

import Foundation
import UIKit
import MapKit

class LocationViewController:UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var place = CLLocationCoordinate2D()
    var url = String()
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        finishButton.layer.cornerRadius = 5
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = place
        annotation.title = AppData.mapString
        mapView.addAnnotation(annotation)
        mapView.setRegion(MKCoordinateRegion(center: place, latitudinalMeters: 400, longitudinalMeters: 400), animated: true)
    }
    
    // ADD_LOCATION BUTTON: Dismiss the LocationViewController
    @IBAction func addLocationButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // FINISH BUTTON: Post users data to parseAPI and dismiss the viewControllers
    @IBAction func finishButton(_ sender: Any) {
        activityIndicatorHandler(finish: true)
        // If the user posts data for first time
        if AppData.objectId == nil {
            ParseAPI.userPostInformation { (response, error) in
                if response{
                    self.dismiss(animated: true, completion: nil)
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                    print(AppData.mediaUrL)
                    self.activityIndicatorHandler(finish: false)
                    
                }
                else {
                    self.showFailure(message: error?.localizedDescription ?? "")
                    self.activityIndicatorHandler(finish: false)
                }
            }
        }
        
        // If user has already posted data then rewrites the existing data
        else{
            ParseAPI.userPutInformation { (response, error) in
                if response{
                    self.dismiss(animated: true, completion: nil)
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                    self.activityIndicatorHandler(finish: false)
                }
                else {
                    self.showFailure(message: error?.localizedDescription ?? "")
                    self.activityIndicatorHandler(finish: false)
                }
            }
        }
    }
    
    // Handles the mapView alpha, activityIndicator animation, button and textFields
    func activityIndicatorHandler(finish:Bool){
        if finish{
            activityIndicator.startAnimating()
            mapView.alpha = 0.7
        }
        else{
            activityIndicator.stopAnimating()
            mapView.alpha = 1
        }
        finishButton.isEnabled = !finish
    }
    
    func showFailure(message: String) {
        let alertVC = UIAlertController(title: "Failed posting data", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
