//
//  APIError.swift
//  Airbnb-clone
//
//  Todos los errores posibles de la capa de red en un solo tipo.
//  Así la UI solo tiene que manejar APIError y mostrar `errorDescription`.
//

import Foundation

enum APIError: LocalizedError {
   /// No se pudo armar la URL con ese path.
   case invalidURL(String)
   /// La respuesta no fue HTTP.
   case invalidResponse
   /// El servidor respondió con un status fuera de 200...299.
   case http(statusCode: Int, data: Data)
   /// Falló la conexión: sin internet, timeout, servidor apagado…
   case transport(URLError)
   /// El JSON no coincide con el modelo Codable.
   case decoding(Error)
   /// Modo local: no existe el archivo JSON en el bundle.
   case mockNotFound(String)
   /// Modo local: el archivo existe pero no tiene esa llave.
   case mockKeyNotFound(keyPath: String, file: String)

   var errorDescription: String? {
      switch self {
      case .invalidURL(let path):
         return "La dirección \"\(path)\" no es válida."
      case .invalidResponse:
         return "El servidor respondió algo inesperado."
      case .http(let statusCode, _):
         switch statusCode {
         case 401: return "Tu sesión expiró. Vuelve a iniciar sesión."
         case 404: return "No encontramos lo que buscabas."
         case 500...599: return "El servidor tuvo un problema (\(statusCode)). Intenta de nuevo."
         default: return "Error del servidor (\(statusCode))."
         }
      case .transport(let error):
         switch error.code {
         case .notConnectedToInternet: return "No tienes conexión a internet."
         case .timedOut: return "El servidor tardó demasiado en responder."
         case .cannotConnectToHost: return "No se pudo conectar con el servidor."
         default: return error.localizedDescription
         }
      case .decoding(let error):
         #if DEBUG
         return "No se pudo leer la respuesta: \(error)"
         #else
         return "No se pudo leer la respuesta."
         #endif
      case .mockNotFound(let file):
         return "No se encontró \(file) en el bundle. ¿Está en Copy Bundle Resources?"
      case .mockKeyNotFound(let keyPath, let file):
         return "\(file).json no tiene la llave \"\(keyPath)\"."
      }
   }
}
