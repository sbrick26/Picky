//
//  ViewController.swift
//  Picky
//
//  Created by Swayam Barik on 7/7/16.
//  Copyright © 2016 Swayam Barik. All rights reserved.
//


import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    @IBOutlet weak var cuisineLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    var defaultCategories: [String] = ["American", "Barbeque", "Buffets", "Burgers", "Cajun", "Chinese",
    "Ethiopian", "French", "Greek", "Indian", "Italian", "Japanese", "Korean", "Latin American","Mediterranean", "Mexican","Middle Eastern", "Noodles", "Pizza", "Sandwiches","Sushi Bars","Thai","Vietnamese"]
    
    var categories: [String] = []
    let locationManager = CLLocationManager()
    static var locValue: CLLocationCoordinate2D!
    var businesses: [Business]!
    var MyPins: MKPinAnnotationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //changing the color of the status bar 
        
        
        
        //Location Services Authorization (Edit the message in the plist)
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            print("location did not work")
        }
        
        
        
//        func test(businesses: [Business]!, myError: NSError!){
//            
//            if let businesses = businesses {
//                print(businesses)
//            }else{
//                print(myError)
//            }
//        }
        
        
        //Brings JSON object

       // Business.searchWithTerm("Thai", categories: "restaurants", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            
//        Business.searchWithTerm("Thai", sort: YelpSortMode.BestMatched, categories: ["restaurants", "chinese"], deals: false, completion: { (businesses: [Business]!, error: NSError!) -> Void in
//            self.businesses = businesses
//            
//            for business in businesses {
//                print(business.name!)
//                print(business.address!)
//            }
//        })
        
        if ViewController.locValue != nil {
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: categories, deals: false) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                    print(business.distance!)
                }
            }
        }
        
        reloadInputViews()
        
        
        
//        let myYelpAPI = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
//        
//        myYelpAPI.searchWithTerm("restaurants", sort: YelpSortMode.Distance, categories: ["Chinese", "Thai"], deals: true, completion: test)
//        
//       

        
    }
    
   
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Updates current location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        ViewController.locValue = manager.location!.coordinate
        //print(ViewController.locValue)
    }
    
    //Gets the DIstance between two locations (in meters)
    func getMeterDistance(location1: CLLocationCoordinate2D, location2: CLLocationCoordinate2D) -> Double {
        let location1CL: CLLocation = CLLocation(latitude: location1.latitude, longitude: location1.longitude)
        let location2CL: CLLocation = CLLocation(latitude: location2.latitude, longitude: location2.longitude)
        
        return location1CL.distanceFromLocation(location2CL)
    }
    
    
    
    
    //Button that gets the distance between the two locations (NEEDS TO BE FUNCTION THAT UPDATES LABELS TO RANDOM RESTAURANT)
    @IBAction func myButton(sender: AnyObject) {
        
//        let restaurantLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.7771697, longitude: -122.4183997)
//        let locValue = locationManager.location!.coordinate
//        let distance = getMeterDistance(locValue, location2: restaurantLocation)
//        print("\(locValue.latitude), \(locValue.longitude)")
//        print("distance: " + String(distance))
        
        let random = UInt32(businesses.count)
        let randomInt = Int(arc4random_uniform(random))
        self.restaurantNameLabel.text = businesses[randomInt].name!
        self.locationLabel.text = businesses[randomInt].address!
        
        self.cuisineLabel.text = businesses[randomInt].categories
        
        
        var location = CLLocationCoordinate2D(
            latitude: businesses[randomInt].latitude,
              longitude: businesses[randomInt].longitude
        )
        
        var span = MKCoordinateSpanMake(0.01, 0.01)
        var region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
        
        
        var annotation = MKPointAnnotation()
        
        
            mapView.removeAnnotations(mapView.annotations)
        
        annotation.coordinate = location
        annotation.title = businesses[randomInt].name!
        annotation.subtitle = businesses[randomInt].address!
        
        mapView.addAnnotation(annotation)
        
    }
    
    
}


//Preferences Tab

extension ViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.darkGrayColor()
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        
        print("Test: ")

        print(defaultCategories[indexPath.row])
        
        
//        print(currentCell.textLabel!.text)
        
        
        
        categories.append(defaultCategories[indexPath.row])

    }
    
    // if tableView is set in attribute inspector with selection to multiple Selection it should work.
    
    // Just set it back in deselect
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.clearColor()
    }
    
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!;
//        
//        print(currentCell.textLabel!.text)
//    }
}
extension ViewController: UITableViewDataSource
{
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 23
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("American")!
            return cell
        }
        else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("Barbeque")!
            return cell
        }
        else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCellWithIdentifier("Buffets")!
            return cell
        }
        else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCellWithIdentifier("Burgers")!
            return cell
        }
        else if indexPath.row == 4{
            let cell = tableView.dequeueReusableCellWithIdentifier("Cajun")!
            return cell
        }
        else if indexPath.row == 5{
            let cell = tableView.dequeueReusableCellWithIdentifier("Chinese")!
            return cell
        }
        else if indexPath.row == 6{
            let cell = tableView.dequeueReusableCellWithIdentifier("Ethiopian")!
            return cell
        }
        else if indexPath.row == 7{
            let cell = tableView.dequeueReusableCellWithIdentifier("French")!
            return cell
        }
        else if indexPath.row == 8{
            let cell = tableView.dequeueReusableCellWithIdentifier("Greek")!
            return cell
        }
        else if indexPath.row == 9{
            let cell = tableView.dequeueReusableCellWithIdentifier("Indian")!
            return cell
        }
        else if indexPath.row == 10{
            let cell = tableView.dequeueReusableCellWithIdentifier("Italian")!
            return cell
        }
        else if indexPath.row == 11{
            let cell = tableView.dequeueReusableCellWithIdentifier("Japanese")!
            return cell
        }
        else if indexPath.row == 12{
            let cell = tableView.dequeueReusableCellWithIdentifier("Korean")!
            return cell
        }
        else if indexPath.row == 13{
            let cell = tableView.dequeueReusableCellWithIdentifier("Latin American")!
            return cell
        }
        else if indexPath.row == 14{
            let cell = tableView.dequeueReusableCellWithIdentifier("Mediterranean")!
            return cell
        }
        else if indexPath.row == 15{
            let cell = tableView.dequeueReusableCellWithIdentifier("Mexican")!
            return cell
        }
        else if indexPath.row == 16{
            let cell = tableView.dequeueReusableCellWithIdentifier("Middle Eastern")!
            return cell
        }
        else if indexPath.row == 17{
            let cell = tableView.dequeueReusableCellWithIdentifier("Noodles")!
            return cell
        }
        else if indexPath.row == 18{
            let cell = tableView.dequeueReusableCellWithIdentifier("Pizza")!
            return cell
        }
        else if indexPath.row == 19{
            let cell = tableView.dequeueReusableCellWithIdentifier("Sandwiches")!
            return cell
        }
        else if indexPath.row == 20{
            let cell = tableView.dequeueReusableCellWithIdentifier("Sushi")!
            return cell
        }
        else if indexPath.row == 21{
            let cell = tableView.dequeueReusableCellWithIdentifier("Greek")!
            return cell
        }
        else if indexPath.row == 22{
            let cell = tableView.dequeueReusableCellWithIdentifier("Thai")!
            return cell
        }
            
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("Vietnamese")!
            return cell
        }
    }
}

