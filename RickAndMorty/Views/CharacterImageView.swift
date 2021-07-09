

import UIKit

class CharacterImageView: UIImageView {
    func fetchImage(from url: String) {
        guard let imageUrl = URL(string: url) else {
            image = UIImage(systemName: "xmark.shield")
            return
        }

        // Используем из кеша
        if let cachedImage = getCachedImage(for: imageUrl) {
            image = cachedImage
            return
        }

        // Если нет в кеше – попросить из сети
        ImageManager.shared.getImage(from: imageUrl) { (data, response) in
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }

            // поместить в кеш
            self.saveDataToCache(with: data, response: response)
        }
    }

    private func saveDataToCache(with data: Data, response: URLResponse) {
        // извлекаем адрес, по которому будет идентифицирована картинка
        guard let url = response.url else { return }
        // запрос для поиска данных в кеше
        let request = URLRequest(url: url)
        // создать кешируемый объект
        let cachedResponse = CachedURLResponse(response: response, data: data)
        // Поместить объект в кеш
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
    }

    private func getCachedImage(for url: URL) -> UIImage? {
        // запрос для поиска данных в кеше
        let request = URLRequest(url: url)

        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            return UIImage(data: cachedResponse.data)
        }

        return nil
    }
}
