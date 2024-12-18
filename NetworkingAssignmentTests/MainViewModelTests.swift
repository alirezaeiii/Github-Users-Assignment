//
//  CachingSwiftDataTests.swift
//  CachingSwiftDataTests
//
//  Created by Ali on 12/16/24.
//

import XCTest
@testable import NetworkingAssignment

final class MainViewModelTests: XCTestCase {
    
    var viewModel: MainViewModel!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = MainViewModel(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        mockNetworkService = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testRefreshWithExistingData() async throws {
        let mockUser = GithubUser(login: "testUser", avatarUrl: "https://example.com/avatar.png", bio: "bio")
        let mockData = try JSONEncoder().encode([mockUser])
        mockNetworkService.mockData = mockData
        
        XCTAssertEqual(viewModel.viewState, .loading)
        await viewModel.refresh()
        
        XCTAssertEqual(viewModel.viewState, .completed)
        XCTAssertEqual(viewModel.users.count, 2)
        XCTAssertEqual(viewModel.users.first?.section, "Following")
        XCTAssertEqual(viewModel.users.first?.users.count, 1)
        XCTAssertEqual(viewModel.users.last?.section, "Followers")
        XCTAssertEqual(viewModel.users.last?.users.count, 1)
        XCTAssertEqual(viewModel.users.first?.users.first?.login, "testUser")
        XCTAssertEqual(viewModel.users.first?.users.first?.avatarUrl, "https://example.com/avatar.png")
        XCTAssertEqual(viewModel.users.first?.users.first?.bio, "bio")
        XCTAssertEqual(viewModel.users.last?.users.first?.login, "testUser")
        XCTAssertEqual(viewModel.users.last?.users.first?.avatarUrl, "https://example.com/avatar.png")
        XCTAssertEqual(viewModel.users.last?.users.first?.bio, "bio")
    }
    
    func testRefreshWithNetworkFailure() async {
        let error = NSError(domain: "TestError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Bad Request"])
        mockNetworkService.mockError = error
        
        XCTAssertEqual(viewModel.viewState, .loading)
        await viewModel.refresh()
        
        XCTAssertEqual(viewModel.viewState, .failure(error: error))
        
    }
    
    func testRefreshWithDecodingError() async {
        mockNetworkService.mockData = Data("Invalid JSON".utf8) // Invalid JSON
        
        XCTAssertEqual(viewModel.viewState, .loading)
        await viewModel.refresh()
        
        if case .failure(let error) = viewModel.viewState {
            XCTAssertTrue(error is DecodingError)
        } else {
            XCTFail("Expected viewState to be .failure but got \(viewModel.viewState)")
        }
    }
}
