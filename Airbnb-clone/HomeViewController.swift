//
//  HomeViewController.swift
//  Airbnb-clone
//
//  Created by Xcaret Mora on 17/02/24.
//
//  La vista en MVVM: se suscribe al ViewModel, le manda eventos
//  (cargar, reintentar) y pinta cada estado. No sabe de dónde vienen los datos.
//

import UIKit

class HomeViewController: UIViewController {

   private lazy var contentView: HomeView = .init()
   private let viewModel: HomeViewModel
   private var statusBarStyle: UIStatusBarStyle = .lightContent
   private let loadingIndicator = UIActivityIndicatorView(style: .large)
   private var loadTask: Task<Void, Never>?

   override var preferredStatusBarStyle: UIStatusBarStyle { statusBarStyle }

   // MARK: - Init

   /// Para crearlo por código o en tests, pasando otro ViewModel.
   init(viewModel: HomeViewModel) {
      self.viewModel = viewModel
      super.init(nibName: nil, bundle: nil)
   }

   /// Main.storyboard crea este view controller con este init.
   required init?(coder: NSCoder) {
      self.viewModel = HomeViewModel()
      super.init(coder: coder)
   }

   deinit {
      loadTask?.cancel()
   }

   // MARK: - Ciclo de vida

   override func loadView() {
      view = contentView
   }

   override func viewDidLoad() {
      super.viewDidLoad()
      setupLoadingIndicator()
      bindViewModel()
      load()
   }

   // MARK: - Binding

   /// Paso 1: la vista escucha los cambios de estado del ViewModel.
   private func bindViewModel() {
      viewModel.onStateChange = { [weak self] state in
         self?.render(state)
      }
   }

   /// Paso 2: la vista le manda el evento "carga" al ViewModel.
   private func load() {
      loadTask?.cancel()
      loadTask = Task { [weak self] in
         await self?.viewModel.load()
      }
   }

   // MARK: - Render

   /// Paso 3: la vista pinta lo que diga el estado.
   private func render(_ state: HomeViewModel.State) {
      switch state {
      case .idle:
         loadingIndicator.stopAnimating()

      case .loading:
         loadingIndicator.startAnimating()

      case .loaded(let feed):
         loadingIndicator.stopAnimating()
         contentView.apply(makeSnapshot(from: feed))

      case .empty:
         loadingIndicator.stopAnimating()
         showMessage(title: "Sin resultados", message: "Por ahora no hay nada que mostrar.")

      case .failed(let message):
         loadingIndicator.stopAnimating()
         showMessage(title: "No se pudo cargar", message: message, canRetry: true)
      }
   }

   /// Convierte el modelo de dominio en el snapshot que entiende la collection view.
   private func makeSnapshot(from feed: HomeFeed) -> NSDiffableDataSourceSnapshot<Section, Content> {
      var snapshot = NSDiffableDataSourceSnapshot<Section, Content>()
      snapshot.appendSections(feed.sections.map(\.section))
      feed.sections.forEach { snapshot.appendItems($0.items, toSection: $0.section) }
      return snapshot
   }

   // MARK: - UI de apoyo

   private func setupLoadingIndicator() {
      loadingIndicator.color = .secondaryLabel
      loadingIndicator.hidesWhenStopped = true
      loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(loadingIndicator)

      // Abajo del header "Go Near", donde aparece la lista.
      NSLayoutConstraint.activate([
         loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         loadingIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                  constant: -120)
      ])
   }

   private func showMessage(title: String, message: String, canRetry: Bool = false) {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      if canRetry {
         alert.addAction(UIAlertAction(title: "Reintentar", style: .default) { [weak self] _ in
            self?.load()
         })
      }
      alert.addAction(UIAlertAction(title: "OK", style: .cancel))
      present(alert, animated: true)
   }
}
