//
//  LocalJSONLoader.swift
//  Airbnb-clone
//
//  Lee un JSON del bundle y, si se pide, regresa solo una parte de él.
//  Lo usa APIClient cuando el entorno es `.local`.
//

import Foundation

struct LocalJSONLoader {
   let bundle: Bundle

   init(bundle: Bundle = .main) {
      self.bundle = bundle
   }

   func load(_ resource: MockResource) throws -> Data {
      guard let url = bundle.url(forResource: resource.file, withExtension: "json") else {
         throw APIError.mockNotFound("\(resource.file).json")
      }

      let data: Data
      do {
         data = try Data(contentsOf: url)
      } catch {
         throw APIError.decoding(error)
      }

      // Sin keyPath se regresa el archivo completo.
      guard let keyPath = resource.keyPath, !keyPath.isEmpty else {
         return data
      }

      // Con keyPath: se recorre el JSON nivel por nivel ("home" o "home.nearby")
      // y se vuelve a convertir en Data solo el fragmento encontrado.
      do {
         var current: Any = try JSONSerialization.jsonObject(with: data)
         for key in keyPath.split(separator: ".").map(String.init) {
            guard let dictionary = current as? [String: Any], let next = dictionary[key] else {
               throw APIError.mockKeyNotFound(keyPath: keyPath, file: resource.file)
            }
            current = next
         }
         return try JSONSerialization.data(withJSONObject: current, options: [.fragmentsAllowed])
      } catch let error as APIError {
         throw error
      } catch {
         throw APIError.decoding(error)
      }
   }
}
