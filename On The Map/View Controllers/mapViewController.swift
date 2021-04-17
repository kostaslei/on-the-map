//
//  mapViewController.swift
//  On The Map
//
//  Created by Kostas Lei on 06/04/2021.
//

import Foundation
import UIKit
import MapKit

class mapViewController: UIViewController{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var logoutButton: UIButton!
    var annotations = [MKPointAnnotation]()
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        refreshData()
    }
    
    
    // LOGOUT BUTTON: Logout the user and erase all the data stored
    @IBAction func LogoutButton(_ sender: Any) {
        UdacityAPI.logout{
            DispatchQueue.main.async{
                self.dismiss(animated: true, completion: nil)
            }}
    }
    
    // REFRESH BUTTON: Calls the refresh func and refreshes the map and the data
    @IBAction func refreshButton(_ sender: Any) {
        refreshData()
    }
    
    // ADD BUTTON: Transfear us to the infoVC
    @IBAction func addButton(_ sender: Any) {
        let vc = (storyboard?.instantiateViewController(identifier: "infoVC"))! as UINavigationController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    // GET_MAP FUNC: Add the annotations to mapView
    func getMap() {
        if annotations != []{
            mapView.removeAnnotations(mapView.annotations)
        }
        annotations = []
        for i in AppData.parseDataResults {
            let lat = CLLocationDegrees(i.latitude )
            let long = CLLocationDegrees(i.longitude )
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = i.firstName
            let last = i.lastName
            let mediaURL = i.mediaURL
            
            // Create the annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Place the annotation in an array of annotations.
            self.annotations.append(annotation)
        }
        self.mapView.addAnnotations(self.annotations)
    }
    // REFRESH_DATA FUNC: Gets students data and present them on the map
    func refreshData(){
        indicator(reload: true)
        ParseAPI.getStudentInformation { (response, error) in
            if error == nil {
                AppData.parseDataResults = []
                AppData.parseDataResults = response
                self.getMap()
                self.indicator(reload: false)
            }
            else{
                self.showFailure(message: error?.localizedDescription ?? "")
                self.getMap()
                self.indicator(reload: false)
            }
        }        
    }
    
    // INDICATOR FUNC: Controlls the activityIndicator, buttons and mapView aplha
    func indicator(reload: Bool){
        if reload{
            activityIndicator.startAnimating()
            mapView.alpha = 0.7
        }
        else{
            activityIndicator.stopAnimating()
            mapView.alpha = 1
        }
        logoutButton.isEnabled = !reload
        reloadButton.isEnabled = !reload
        addButton.isEnabled = !reload
    }
    
    func showFailure(message: String) {
        let alertVC = UIAlertController(title: "Failed downloading data", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}

// EXTENTION: Adds mapView functionallity
extension mapViewController:MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoLight)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open((URL(string: toOpen) ?? URL(string: "https://www.google.com"))!)
            }
        }
    }
}
