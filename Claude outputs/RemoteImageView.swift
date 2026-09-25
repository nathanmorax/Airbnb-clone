//
//  RemoteImageView.swift
//  Airbnb-clone
//
//  UIImageView que descarga su imagen por URL, la guarda en caché
//  y cancela la descarga si la celda se reutiliza antes de terminar.
//

import UIKit

enum ImageCache {
   static let shared: NSCache<NSURL, UIImage> = {
      let cache = NSCache<NSURL, UIImage>()
      cache.countLimit = 200
      return cache
   }()
}

final class RemoteImageView: UIImageView {

   private var task: Task<Void, Never>?
   private var currentURL: URL?

   func setImage(from url: URL?, placeholder: UIImage? = nil) {
      cancel()
      currentURL = url
      image = placeholder

      guard let url else { return }

      if let cached = ImageCache.shared.object(forKey: url as NSURL) {
         image = cached
         return
      }

      task = Task { [weak self] in
         do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard !Task.isCancelled, let downloaded = UIImage(data: data) else { return }
            ImageCache.shared.setObject(downloaded, forKey: url as NSURL)
            guard let self, self.currentURL == url else { return }
            UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve) {
               self.image = downloaded
            }
         } catch {
            // Se deja el placeholder; en una app real podrías mostrar un ícono de error.
         }
      }
   }

   /// Llámalo desde prepareForReuse() de la celda.
   func cancel() {
      task?.cancel()
      task = nil
   }
}
