//
//  QueryService.swift
//  LocationTracker
//
//  Created by KeshanWithanage on 21/5/19.
//  Copyright © 2019 KeshanWithanage. All rights reserved.


import Foundation

class QueryResults {
    
    var loction = [mapLocation]()
    
    
    typealias QueryResult = ([mapLocation]?) -> ()
    
    func parseJSONOnline(completion: @escaping QueryResult) {
        guard let url = URL(string: "https://data.melbourne.vic.gov.au/resource/vh2v-4nfs.json?$limit=250") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in guard let data = data else { return }
            do {
                
                self.loction = try JSONDecoder().decode([mapLocation].self, from: data)
                print(self.loction)
            } catch let err {
                print("Err", err)
            }
            
            DispatchQueue.main.async {
                completion(self.loction)
            }
            }.resume()
        print(loction)
    }
}
