//
//  BabyTunesTests.swift
//  BabyTunesTests
//
//  Created by Alan Aherne Restore on 25.01.15.
//  Copyright (c) 2015 CCDimensions. All rights reserved.
//

import UIKit
import XCTest

class BabyTunesTests: FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        
        self.recordMode = false;
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
