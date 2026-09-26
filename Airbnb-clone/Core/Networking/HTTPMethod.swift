//
//  HTTPMethod.swift
//  Airbnb-clone
//
//  Los verbos HTTP que usa la app. Usar un enum en lugar de Strings
//  evita errores de dedo como "GTE" o "post".
//

import Foundation

enum HTTPMethod: String {
   case get = "GET"
   case post = "POST"
   case put = "PUT"
   case patch = "PATCH"
   case delete = "DELETE"
}
