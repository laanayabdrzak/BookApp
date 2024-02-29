//
//  ContentViewModel.swift
//  BookAppMVVM
//
//  Created by LAANAYA Abderrazak on 11/7/2023.
//

import Foundation
import Combine

/* The `res` property has been removed since it wasn't being used.
 The `cancellable` property has been renamed to cancellables and changed to a Set<AnyCancellable> to handle multiple cancellables.
 The fetch operations now use the decode operator to decode the response into the specified types ([Book].self and CommercialOffersResponse.self).
 The `replaceError` operator is used to handle any decoding errors and provide a default value.
 The `publisher` chain now uses receive(on: DispatchQueue.main) to ensure the assignment and updates are performed on the main queue (UI thread).
 The assign operator is used to assign the received values to the appropriate properties (books and discountedPrice).
 Cancellables are stored in the cancellables set to keep track of them and cancel them if needed. */

class ContentViewModel: ObservableObject {
    
    @Published var books: [Book] = []
    @Published var discountedPrice: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    private var networkManager: AnyNetworkManager<URLSession>?
    
    init() {
        self.networkManager = AnyNetworkManager(manager: NetworkManager(session: URLSession.shared))
        fetchBooks()
    }
    
    func fetchBooks() {
        networkManager?.fetch(url: URL(string: "https://henri-potier.techx.fr/books")!, method: .get)
            .decode(type: [Book].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.books, on: self)
            .store(in: &cancellables)
    }
    
    func applyDiscount(for books: Set<Book>) {
        let isbns = books.map { $0.isbn }
        networkManager?.fetch(url: URL(string: "https://henri-potier.techx.fr/books/\(isbns.joined(separator: ","))/commercialOffers")!, method: .get)
            .decode(type: CommercialOffersResponse.self, decoder: JSONDecoder())
            .replaceError(with: CommercialOffersResponse(offers: []))
            .map({ [weak self] offers -> Int in
                guard let self = self else { return 0 }
                let bookPrices = books.map { $0.price }
                return self.calculateFinalPrice(bookPrices: bookPrices, offers: offers.offers)
            })
            .receive(on: DispatchQueue.main)
            .assign(to: \.discountedPrice, on: self)
            .store(in: &cancellables)
    }
    
    func calculateFinalPrice(bookPrices: [Int], offers: [Offer]) -> Int {
        var finalPrices: [Int] = []
        
        for offer in offers {
            var finalPrice = bookPrices.reduce(0, +)
            switch offer.type {
            case "percentage":
                let discount = Double(offer.value) / 100.0
                finalPrice -= Int(Double(finalPrice) * discount)
            case "minus":
                finalPrice -= offer.value
            case "slice":
                if let sliceValue = offer.sliceValue {
                    let numSlices = finalPrice / sliceValue
                    let refund = numSlices * offer.value
                    finalPrice -= refund
                }
            default:
                break
            }
            finalPrices.append(finalPrice)
        }
        
        return finalPrices.min() ?? 0
    }
}
