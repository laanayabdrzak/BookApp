//
//  CalculatePriceTests.swift
//  BookAppMVVMTests
//
//  Created by LAANAYA Abderrazak on 19/7/2023.
//

import XCTest
@testable import BookAppMVVM

final class CalculatePriceTests: XCTestCase {

   
    func testFinalPriceCalculation() {
        // Given (Arrange)
        let vm = ContentViewModel()
        let bookPrices = [35, 30]
        
        let offer1 = Offer(type: "percentage",
                           value: 5,
                           sliceValue: 0)
        let offer2 = Offer(type: "minus",
                           value: 15,
                           sliceValue: 0)
        let offer3 = Offer(type: "slice",
                           value: 12,
                           sliceValue: 100)
        
        let offers: [Offer] = [offer1, offer2, offer3]
        
        // When (Act)
        
        let clcFP = vm.calculateFinalPrice(bookPrices: bookPrices, offers: offers)
        
        // Then (Assert)
        
        XCTAssertEqual(clcFP, 50)
    }

}
