//
//  scf.swift
//  Characters
//
//  Created by Sujananth Visvaratnam on 26/10/19.
//  Copyright © 2019 Sujananth. All rights reserved.
//



struct CharactersModel: Codable {
    
    var characters: [Character]
    
    enum CodingKeys: String, CodingKey {
        case characters = "RelatedTopics"
    }
}

struct Character: Codable {
    
    var detail: String?
    var icon: Icon
    
    enum CodingKeys: String, CodingKey {
        case detail = "Text"
        case icon = "Icon"
    }
    
    func getCharacterName() -> String {
        var strArray = detail?.components(separatedBy: "-")
        return strArray?[0] ?? ""
    }
    
    /* Method to separate title and detail.*/
    func getCharacterDetail() -> String {
        let strArray = detail?.replacingOccurrences(of: getCharacterName(), with: "")
        return strArray ?? ""
    }
}

struct Icon: Codable {
    
    var imageURL: String?

    enum CodingKeys: String, CodingKey {
        case imageURL = "URL"
    }
}
