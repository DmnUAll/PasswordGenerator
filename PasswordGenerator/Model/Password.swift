//
//  Password.swift
//  PasswordGenerator
//
//  Created by Илья Валито on 19.09.2021.
//

import Foundation

enum Characters: String{
    case lowerCase = "abcdefghijklmnopqrstuvwxyz"
    case upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    case numbers = "1234567890"
    case special = " !\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
}

struct Password{
    
    func generate(_ groups: Set<Characters.RawValue>, _ numberOfCharacters: Int) -> String{
        
        var groupsArray: [String] = []
        var result: String = ""
        
        for group in groups {
            groupsArray.append(group)
        }
        
        for _ in 1...numberOfCharacters {
            result.append(groupsArray.randomElement()!.randomElement()!)
        }
        
        return result
    }
}
