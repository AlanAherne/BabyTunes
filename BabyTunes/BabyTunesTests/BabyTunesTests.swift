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
    
    func testViewExample() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        view.backgroundColor = UIColor.blueColor()
        FBSnapshotVerifyView(view)
        FBSnapshotVerifyLayer(view.layer)
    }

    func testMainViewControllerLanguageButton() {
        let sut = BTViewController()
        assertThat( sut.menu, nilValue())
    }
    
    func testMainViewController() {
        let viewController = BTViewController()
        let frame = CGRectMake(0, 0, 300, 500)
        viewController.view.frame = frame
        FBSnapshotVerifyView(viewController.view)
    }
}
