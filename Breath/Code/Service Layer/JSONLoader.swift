import Foundation

protocol JSONLoader {
    func loadJSON(bundle: Bundle, from resourceName: String, ofType type: String) -> [JSON]
    func loadJSON(bundle: Bundle, from resourceName: String, ofType type: String, completion: @escaping ([JSON]) -> Void)
}

protocol HasJSONLoader {
    var jsonLoader: JSONLoader { get }
}

class JSONLoaderImpl: JSONLoader {
    func loadJSON(bundle: Bundle, from resourceName: String, ofType type: String) -> [JSON] {
        guard let path = bundle.path(forResource: resourceName, ofType: type) else { return [] }
        do {
            let data = try NSData(contentsOfFile: path, options: .alwaysMapped) as Data
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            if let singleJson = json as? JSON {
                return [singleJson]
            } else if let jsonArray = json as? [JSON] {
                return jsonArray
            }
            return []
        } catch {
            print(error)
            return []
        }
    }

    func loadJSON(bundle: Bundle, from resourceName: String, ofType type: String, completion: @escaping ([JSON]) -> Void) {
        OperationQueue().addOperation { [weak self] in
            guard let strongSelf = self else { return }
            let json = strongSelf.loadJSON(bundle: bundle, from: resourceName, ofType: type)
            completion(json)
        }
    }
}
