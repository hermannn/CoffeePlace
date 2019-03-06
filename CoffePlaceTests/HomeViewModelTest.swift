//
//  HomeViewModelTest.swift
//  CoffePlaceTests
//
//  Created by Hermann Dorio on 04/03/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import XCTest
import CoreLocation
@testable import CoffePlace

class HomeViewModelTest: XCTestCase {

    var service:MockService!
    var viewModel: HomeViewModel!
    
    override func setUp() {
        service = MockService()
        viewModel = HomeViewModel(service: service)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        service = nil
        viewModel = nil
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetCoffeePlaceWS() {
        Location.shared.currentLocation = CLLocation(latitude: 37.33233141, longitude: -122.0312186)
        viewModel.getCurrentLocation()
        
        XCTAssert(service.isGetCoffeePlaceWasCalled, "WS getCoffeePlace should be call as expected !")
    }
    
    func testGetCoffeePlaceWSMissLatAndLong() {
        Location.shared.currentLocation = nil
        viewModel.getCurrentLocation()
        
        XCTAssert(!service.isGetCoffeePlaceWasCalled, "WS getCoffeePlace shouldn't be called because there are no longitude and latitude!")
    }
    
    func testStaticTextFromViewModel() {
        XCTAssert((viewModel.navigationItemTitleString == "Coffee Place"), "viewModel.navigationItemTitleString not match with Coffee Place")
        XCTAssert((viewModel.identifierAnnotationCoffee == "annotationCoffee"), "viewModel.identifierAnnotationCoffee not match with annotationCoffee")
        XCTAssert((viewModel.listIconPlaceHolderString == "list_icon_placeholder"), "viewModel.listIconPlaceHolderString not match with list_icon_placeholder")
        XCTAssert((viewModel.heartImageFilledString == "heart_filled"), "viewModel.heartImageFilledSting not match with heart_filled")
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
