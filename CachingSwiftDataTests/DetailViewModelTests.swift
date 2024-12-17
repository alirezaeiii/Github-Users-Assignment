//
//  DetailViewModelTests.swift
//  CachingSwiftDataTests
//
//  Created by Ali on 12/16/24.
//

import XCTest
@testable import NetworkingAssignment

final class DetailViewModelTests: XCTestCase {

    var viewModel: DetailViewModel!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = DetailViewModel(networkService: mockNetworkService, githubUser: GithubUser(login: "testUser", avatarUrl: "https://example.com/avatar.png", bio: nil))
    }
    
    override func tearDown() {
        mockNetworkService = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testRefreshWithExistingData() async throws {
        let mockUser = GithubUser(login: "testUser", avatarUrl: "https://example.com/avatar.png", bio: "bio")
        let mockData = try JSONEncoder().encode(mockUser)
        mockNetworkService.mockData = mockData
        
        XCTAssertEqual(viewModel.viewState, .loading)
        await viewModel.refresh()
        
        XCTAssertEqual(viewModel.viewState, .completed)
        XCTAssertNotNil(viewModel.user)
        XCTAssertEqual(viewModel.user?.login, "testUser")
        XCTAssertEqual(viewModel.user?.avatarUrl, "https://example.com/avatar.png")
        XCTAssertEqual(viewModel.user?.bio, "bio")
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
