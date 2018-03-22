import Foundation

class JSONLoader {
    func loadJSON(bundle: Bundle, from resourceName: String, ofType type: String) throws -> JSON {
        guard let path = bundle.path(forResource: resourceName, ofType: type) else { return [:] }
        do {
            let data = try NSData(contentsOfFile: path, options: .alwaysMapped) as Data
            guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? JSON else { return [:] }
            return json
        } catch {
            print(error)
            return [:]
        }
    }
}
