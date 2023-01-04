import Foundation

// MARK: - Characters
enum Characters: String {
    case lowerCase = "abcdefghijklmnopqrstuvwxyz"
    case upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    case numbers = "1234567890"
    case special = " !\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
}

// MARK: - Password
struct Password {

    func generate(_ groups: Set<Characters.RawValue>, _ numberOfCharacters: Int) -> String {

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
