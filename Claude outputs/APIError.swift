//
//  APIError.swift
//  Airbnb-clone
//

import Foundation

enum APIError: LocalizedError {
   case invalidURL
   case invalidResponse
   case http(statusCode: Int, data: Data)
   case decoding(Error)
   case transport(URLError)

   /// true cuando el usuario salió de la pantalla y el request se canceló.
   /// En ese caso no muestres ningún error.
   var isCancellation: Bool {
      if case .transport(let error) = self { return error.code == .cancelled }
      return false
   }

   var errorDescription: String? {
      switch self {
      case .invalidURL:
         return "La dirección del servidor no es válida."
      case .invalidResponse:
         return "El servidor respondió algo inesperado."
      case .http(let statusCode, _):
         switch statusCode {
         case 401: return "Tu sesión expiró. Vuelve a iniciar sesión."
         case 404: return "No encontramos lo que buscabas."
         case 500...599: return "El servidor tuvo un problema (\(statusCode)). Intenta de nuevo."
         default: return "Error del servidor (\(statusCode))."
         }
      case .decoding(let error):
         #if DEBUG
         return "No se pudo leer la respuesta: \(error)"
         #else
         return "No se pudo leer la respuesta."
         #endif
      case .transport(let error):
         switch error.code {
         case .notConnectedToInternet: return "No tienes conexión a internet."
         case .timedOut: return "El servidor tardó demasiado en responder."
         case .cannotConnectToHost: return "No se pudo conectar. ¿Está corriendo el mock server (npm start)?"
         default: return error.localizedDescription
         }
      }
   }
}
