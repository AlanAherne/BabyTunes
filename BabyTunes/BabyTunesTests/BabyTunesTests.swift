//
//  BabyTunesTests.swift
//  BabyTunesTests
//
//  Created by Alan Aherne Restore on 25.01.15.
//  Copyright (c) 2015 CCDimensions. All rights reserved.
//

import UIKit
import Hamcrest
import FBSnapshotTestCase

class BabyTunesTests: FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        
        self.recordMode = true;
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
    
    func testMainViewControllerLanguageButton() {
        let sut = BTViewController()
        assertThat( sut.menu, nilValue())
    }
    
    func testMainViewController() {
        let v = BTViewController()
        
        var error : NSError? = nil
        let success = self.compareSnapshotOfView(v.view, referenceImagesDirectory : FB_REFERENCE_IMAGE_DIR, identifier: nil, error: &error)
        if success{
            if let theError = error
            {
                let reason : String? = theError.localizedDescription
                println("Error BabyTunes : \(reason)")
            }
        }
    }
}
