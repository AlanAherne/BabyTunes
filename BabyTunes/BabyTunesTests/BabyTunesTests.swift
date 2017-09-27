//
//  BabyTunesTests.swift
//  BabyTunesTests
//
//  Created by Alan Aherne Restore on 27.10.15.
//  Copyright © 2015 CCDimensions. All rights reserved.
//
import BabyTunes
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
    
    func testBTSongTableCell()
    {
        let songTableCell = BTSongTableCell(style: .default, reuseIdentifier: nil)
        let songTest:Song = Song(fromLanguage: "german", songTitle: "Test")
        songTableCell.configure(songTest)
        FBSnapshotVerifyView(songTableCell)
    }
}
