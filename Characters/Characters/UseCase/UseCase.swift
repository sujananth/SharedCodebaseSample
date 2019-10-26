//
//  UseCase.swift
//  Characters
//
//  Created by Sujananth Visvaratnam on 26/10/19.
//  Copyright © 2019 Sujananth. All rights reserved.
//

import UIKit

/*
 A class to handle network calls
 */
class UseCase {
    
    static let shared = UseCase()
    
    /*
     Method to download and decode JSON from the URL aded in build configuration
     */
    func getCharacters(completionHandler: @escaping (Error?,CharactersModel?) -> Void) {
        guard let urlString = getInfoDictionary()?["DataAPI"] as? String, let charactersURL = URL(string: urlString) else {
            return
        }
        let jsonDownloadTask = URLSession.shared.dataTask(with: charactersURL) { (downloadedData, response, error) in
            
            guard error == nil, let charactersData = downloadedData, let charactersList = try? JSONDecoder().decode(CharactersModel.self, from: charactersData) else {
                return completionHandler(error,nil)
            }
            completionHandler(nil,charactersList)
        }
        jsonDownloadTask.resume()
    }
    
    /*
     Method to get plist Dictionary
     */
    private func getInfoDictionary() -> [String: AnyObject]? {
        guard let infoDictPath = Bundle.main.path(forResource: "Info", ofType: "plist") else { return nil }
        return NSDictionary(contentsOfFile: infoDictPath) as? [String : AnyObject]
    }
}
