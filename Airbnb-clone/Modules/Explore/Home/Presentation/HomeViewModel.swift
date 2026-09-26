//
//  HomeViewModel.swift
//  Airbnb-clone
//
//  Tiene la lógica de la pantalla: pide los datos al Repository y
//  convierte el resultado en un estado que la vista sabe pintar.
//  No importa UIKit: no sabe nada de celdas, colores ni snapshots.
//

import Foundation

@MainActor
final class HomeViewModel {

   /// Todo lo que la pantalla puede estar mostrando.
   enum State: Equatable {
      case idle                       // todavía no se pide nada
      case loading                    // esperando datos
      case loaded(HomeFeed)           // datos listos
      case empty                      // llegó la respuesta, pero sin contenido
      case failed(message: String)    // algo salió mal
   }

   /// Cada vez que cambia el estado, se avisa a la vista.
   private(set) var state: State = .idle {
      didSet { onStateChange?(state) }
   }

   /// La vista se suscribe aquí para redibujarse.
   var onStateChange: ((State) -> Void)?

   private let repository: HomeRepositoryProtocol

   init(repository: HomeRepositoryProtocol = HomeRepository()) {
      self.repository = repository
   }

   // MARK: - Eventos que manda la vista

   func load() async {
      // Evita pedir dos veces si ya está cargando.
      guard state != .loading else { return }

      state = .loading
      do {
         let feed = try await repository.fetchHome()
         state = feed.isEmpty ? .empty : .loaded(feed)
      } catch let error where error.isCancellation {
         // El usuario salió de la pantalla: no es un error que mostrar.
         state = .idle
      } catch {
         state = .failed(message: (error as? LocalizedError)?.errorDescription
                         ?? "Algo salió mal. Intenta de nuevo.")
      }
   }

   func retry() async {
      await load()
   }
}

private extension Error {
   /// Cancelaciones de Swift Concurrency o de URLSession.
   var isCancellation: Bool {
      if self is CancellationError { return true }
      if case .transport(let urlError) = self as? APIError, urlError.code == .cancelled { return true }
      return false
   }
}
