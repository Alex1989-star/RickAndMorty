
import Foundation

class ImageManager {
    static var shared = ImageManager()

    private init() {}

    func fetchImage(from url: String?) -> Data? {
        guard let stringURL = url else { return nil }
        guard let imageURL = URL(string: stringURL) else { return nil }
        return try? Data(contentsOf: imageURL)
    }

    func getImage(from url: URL, completion: @escaping (Data, URLResponse) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }

            guard url == response.url else { return }

            completion(data, response)
        }.resume()
    }
}
