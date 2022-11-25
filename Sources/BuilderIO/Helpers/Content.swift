import Foundation

public struct Content {
    public static func getContent(model: String, apiKey: String, url: String, callback: @escaping ((BuilderContent?)->())) {
        let encodedUrl = String(describing: url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
        let str = "https://cdn.builder.io/api/v2/content/\(model)?apiKey=\(apiKey)&url=\(encodedUrl)"
        let url = URL(string: str)!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                callback(nil)
                return
            }
            let decoder = JSONDecoder()
            let jsonString = String(data: data, encoding: .utf8)!
            print("jsonString = \(jsonString)")
            do {
                let content = try decoder.decode(BuilderContentList.self, from: Data(jsonString.utf8))
                if content.results.count>0 {
                    callback(content.results[0])
                    /*
                    print("file = \(#file) \(#function) \(#line)")
                    print("content.results[0].data.blocks[0] = \(String(describing: content.results[0].data.blocks[0]))")
                    print("responsiveStyles = \(String(describing: content.results[0].data.blocks[0].responsiveStyles))")
                     */
                }
            } catch {
                print(error)
                callback(nil)
            }
        }
        
        task.resume()
    }
}
