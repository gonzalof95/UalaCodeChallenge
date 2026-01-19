//
//  ViewModel.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

import Foundation
import Combine

final class CitiesViewModel: ObservableObject {
    @Published private(set) var cities: [City] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    private let service: CitiesServiceProtocol
    private let logger: Logger
    private var cancellables = Set<AnyCancellable>()

    init(service: CitiesServiceProtocol, logger: Logger = ConsoleLogger()) {
        self.service = service
        self.logger = logger
    }

    func loadCities() {
        logger.log("Loading cities…")
        isLoading = true
        errorMessage = nil

        service.fetchCities()
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false

                if case .failure(let error) = completion {
                    self.logger.error("Failed loading cities: \(error)")
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] (cities: [City]) in
                guard let self else { return }
                self.logger.log("Loaded \(cities.count) cities")
                self.cities = cities
            }
            .store(in: &cancellables)
    }
}

