//
//  FilmListVM.swift
//  VoioFilmsApp
//
//  Created by Evhen Lukhtan on 29.03.2023.
//

import Alamofire
import Combine
import Foundation

final class FilmListVM {
    
    // MARK: - Properties
    @Published var films = [Film]()
    @Published var searchText = ""
    @Published var filterSettings = ["Harry", "King", "Spider"]
    private var cancellables = Set<AnyCancellable>()
    private let fetchMoreSubject = PassthroughSubject<Void, Never>()
    private var currentPage = 1
    private let productsPerPage = 50
    private var isFetchInProgress = false
    private var hasMore = true
    
    
    // MARK: - Initialization
    init() {
        self.setupCombine()
    }
    
    // MARK: - Private funtions
    private func setupCombine() {
        let search = $searchText
            .removeDuplicates()
            .map { [unowned self] text -> (Int, String, [String]) in
                self.resetData()
                return (self.currentPage, text, self.filterSettings)
            }
        
        let filter = $filterSettings
            .removeDuplicates()
            .dropFirst()
            .map { [unowned self] settings -> (Int, String, [String]) in
                self.resetData()
                return (self.currentPage, self.searchText, settings)
            }
        
        let fetchMore = fetchMoreSubject
            .map { [unowned self] in
                (self.currentPage, self.searchText, self.filterSettings)
            }
        
        fetchMore.merge(with: search, filter)
            .flatMap { [unowned self] pageNumber, text, settings in
                self.getProducts(pageNumber: pageNumber, filterParams: settings, searchText: text)
            }
            .replaceError(with: films)
            .sink { [weak self] newProducts in
                self?.updateProducts(newProducts)
            }
            .store(in: &cancellables)
    }
    
    
    private func getProducts(pageNumber: Int, filterParams: [String], searchText: String)
    -> AnyPublisher<[Film], Error> {
//        guard !isFetchInProgress && hasMore else {
//            return Empty(completeImmediately: false).eraseToAnyPublisher()
//        }
        isFetchInProgress = true
//        let link = "https://api.themoviedb.org/3/movie/now_playing?api_key=ebea8cfca72fdff8d2624ad7bbf78e4c&language=uk-UK&page=\(pageNumber)"
        let link = "https://api.themoviedb.org/3/search/movie?api_key=ebea8cfca72fdff8d2624ad7bbf78e4c&language=en-US&query=\(searchText)&page=\(pageNumber)&include_adult=false"
        let request = AF.request(link)
        
        return request.publishDecodable(type: FilmsResults.self)
            .tryMap { response in
                print(response.error.debugDescription)
                guard let films = response.value else {
                    throw AFError.responseSerializationFailed(reason: .inputFileNil)
                }
                return films.results
            }
            .eraseToAnyPublisher()
    }
    
    private func resetData() {
        hasMore = true
        isFetchInProgress = false
        currentPage = 1
        films.removeAll()
    }
    
    private func updateProducts(_ newProducts: [Film]) {
        hasMore = newProducts.count >= productsPerPage
        films.append(contentsOf: newProducts)
        currentPage += 1
        isFetchInProgress = false
    }
    
    // MARK: - Functions
    func fetchNextPage() {
        fetchMoreSubject.send()
    }
}
