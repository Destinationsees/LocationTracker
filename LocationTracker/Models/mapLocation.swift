//
//  mapLocation.swift
//  LocationTracker
//
//  Created by KeshanWithanage on 21/5/19.
//  Copyright © 2019 KeshanWithanage. All rights reserved.
//

import Foundation
import CoreLocation

struct mapLocation: Codable {
    let  bayID, lat: String
    let lon, stMarkerID: String
    let status: Status
    
    enum CodingKeys: String, CodingKey {
        case bayID = "bay_id"
        case lat, lon
        case stMarkerID = "st_marker_id"
        case status
    }
    
    
    var locationx: CLLocation {
        let xla = (self.lat as NSString).doubleValue
        let xlo = (self.lon as NSString).doubleValue
        return CLLocation(latitude: xla, longitude: xlo)
    }
    
    func distance(to locationx: CLLocation) -> CLLocationDistance {
        return locationx.distance(from: self.locationx)
    }
    
}

enum HumanAddress: String, Codable {
    case addressCityStateZip = "{\"address\": \"\", \"city\": \"\", \"state\": \"\", \"zip\": \"\"}"
}

enum Status: String, Codable {
    case present = "Present"
    case unoccupied = "Unoccupied"
}

typealias Welcome = [mapLocation]
