//
//  ViewController.swift
//  gdzieJestem
//
//  Created by Kamil Wójcik on 27.05.2016.
//  Copyright © 2016 Kamil Wójcik. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var szerGeo: UILabel!
    @IBOutlet weak var dłGeog: UILabel!
    @IBOutlet weak var kierunek: UILabel!
    @IBOutlet weak var szybkość: UILabel!
    @IBOutlet weak var wysokość: UILabel!
    @IBOutlet weak var adres: UILabel!
    @IBOutlet weak var mapa: MKMapView!
    
    var manager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        
        var lokalizacjaUżytkownika: CLLocation = locations[0] as CLLocation
        
        var szerokośćGeogrUzytkownika = lokalizacjaUżytkownika.coordinate.latitude
        var długośćGeogrUzytkownika = lokalizacjaUżytkownika.coordinate.longitude //ustawiamy zmienne jako dane z gpsa
        //reszta jest podobnie jak wyżej
        let szerokośćDelta: CLLocationDegrees = 0.01
        let długośćDelta: CLLocationDegrees = 0.01 //różnica pomiedzy długościami na ekranie
        let span: MKCoordinateSpan = MKCoordinateSpanMake(szerokośćDelta, długośćDelta)
        let lokalizacja: CLLocationCoordinate2D = CLLocationCoordinate2DMake(szerokośćGeogrUzytkownika, długośćGeogrUzytkownika)
        
        let region: MKCoordinateRegion = MKCoordinateRegionMake(lokalizacja, span)
        self.mapa.setRegion(region, animated: true)
        
        szerGeo.text = "\(lokalizacjaUżytkownika.coordinate.latitude)"
        dłGeog.text = "\(lokalizacjaUżytkownika.coordinate.longitude)"
        szybkość.text = "\(lokalizacjaUżytkownika.speed)"
        kierunek.text = "\(lokalizacjaUżytkownika.course)"
        wysokość.text = "\(lokalizacjaUżytkownika.altitude)"
        
        //geocoder zamienia adres na lokalizacje, reverse czyli odwrotna zamienia lockalizacje na adres
        CLGeocoder().reverseGeocodeLocation(lokalizacjaUżytkownika) { (placemarks: [CLPlacemark]?, error) in
            
            if error != nil{
                print(error)
            }else{
                let p = CLPlacemark(placemark: (placemarks?[0])!)
                
                var numerUlicy: String = ""
                var ulica: String = ""
                var miasto: String = ""
                var kodPocztowy: String = ""
                var państwo: String = ""
                var cośtam: String = ""
                if p.subThoroughfare != nil {
                    numerUlicy = p.subThoroughfare!
                }
                if p.thoroughfare != nil{
                    cośtam = p.thoroughfare!
                }
                if p.locality != nil{
                    ulica = p.locality!
                }
                if p.subLocality != nil{
                    miasto = p.subLocality!
                }
                if p.postalCode != nil{
                    kodPocztowy = p.postalCode!
                }
                if p.country != nil{
                    państwo = p.country!
                }
                    self.adres.text = "\(numerUlicy) \(cośtam)\n\(miasto) \(kodPocztowy) \(państwo) "
                }
            
        }



    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

