//
//  BabyTunesTests.swift
//  BabyTunesTests
//
//  Created by Alan Aherne Restore on 27.10.15.
//  Copyright © 2015 CCDimensions. All rights reserved.
//

import XCTest
@testable import BabyTunes

class BabyTunesTests: FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        self.recordMode = true;
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample()
    {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample()
    {
        // This is an example of a performance test case.
        self.measureBlock
            {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testBTSongTableCell()
    {
        let subject = BTSongTableCell(style: .Default, reuseIdentifier: nil)
        subject.configure(Song)
    }
}
