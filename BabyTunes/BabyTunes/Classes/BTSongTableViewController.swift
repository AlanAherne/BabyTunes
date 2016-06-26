
//
//  BTSongTableViewController.swift
//  BabyTunes
//
//  Created by Alan Aherne on 30/01/15.
//  Copyright (c) 2014 Alan Aherne. All rights reserved.
//
import BabyTunes
import UIKit
import Parse

// MARK: - enums

enum Language : Int
{
    case ENGLAND, GERMANY, FRANCE, SPAIN

    static let languageNames = [ENGLAND : "english", GERMANY : "german", FRANCE : "french", SPAIN : "spanish"]
    static let languageMouseNames = [ENGLAND : "MouseEN", GERMANY : "MouseDE", FRANCE : "MouseFR", SPAIN : "MouseSP"]
    
    func languageName() -> String
    {
        if let languageName = Language.languageNames[self]
        {
            return languageName
        }
        else
        {
            return "language"
        }
    }
    
    func languageMouseName() -> String
    {
        if let languageMouseName = Language.languageMouseNames[self]
        {
            return languageMouseName
        }
        else
        {
            return "languageMouseName"
        }
    }
    
    func languageMouseCharacterIconImage() -> UIImage!
    {
        return UIImage(named: "\(languageMouseName())")
    }
    
    func languageMouseCharacterImage() -> UIImage!
    {
        return UIImage(named: "Big\(languageMouseName())")
    }
}

// MARK: - BTSongTableViewController

class BTSongTableViewController: UIViewController, SphereMenuDelegate, UIScrollViewDelegate, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    var dataSource : BTSongTableViewDataSource?
    
    var menu : SphereMenu!
    
    // MARK: - View Management
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        if (self.tableView != nil)
        {
            self.tableView!.delegate = self
            self.dataSource = BTSongTableViewDataSource()
            self.tableView!.dataSource = dataSource
        }
        
        self.dataSource!.loadSongsForLanguage(self.tableView, language: Language.GERMANY.languageName())
        
        self.view.backgroundColor = UIColor(red:0.2, green:0.38, blue:0.8, alpha:1)
        
        var j: Int = 0
        var images:[UIImage] = []
        while let language = Language(rawValue: j) {
            
            let image = language.languageMouseCharacterIconImage()
            images.append(image)
            j += 1
            if (j > 6) {break}
        }
        
        let bounds: CGRect = UIScreen.mainScreen().bounds
        let width:CGFloat = bounds.size.width
        let height:CGFloat = bounds.size.height
        
        menu = SphereMenu(startPoint: CGPointMake(width * 0.5, height - 50), startImage: Language.GERMANY.languageMouseCharacterIconImage(), submenuImages:images)
        menu.delegate = self
        self.view.addSubview(menu)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask
    {
        let orientation: UIInterfaceOrientationMask = [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
        return orientation
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UIScrollviewViewDelegate
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        menu.shrinkSubmenu()
    }
    
    // MARK: - SphereMenuDelegate
    
    func sphereDidSelected(index: Int)
    {
        if let languageIndex = Language(rawValue : index)
        {
            self.dataSource!.loadSongsForLanguage(self.tableView, language: languageIndex.languageName())
        
//            let opts : UIViewAnimationOptions = .TransitionFlipFromLeft
//            UIView.transitionWithView(self.languageMouseImageView, duration: 0.8, options: opts,
//                animations: {
//                    self.languageMouseImageView.image = languageIndex.languageMouseCharacterImage()
//                }, completion: nil)
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        SlideInCellAnimator.animate(cell)
    }
}

// MARK: - BTSongTableViewDataSource

class BTSongTableViewDataSource: NSObject, UITableViewDataSource
{
    var tableCellsArray: [BabyTunes.Song] = []
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableCellsArray.count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 120
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("BTSongTableCell", forIndexPath: indexPath) as! BTSongTableCell
        cell.configure(tableCellsArray[indexPath.row])
        return cell
    }
    
    // MARK: - Helpers
    
    func loadSongsForLanguage(tableView: UITableView, language: String )
    {
        self.tableCellsArray.removeAll()
        
        let query = PFQuery(className: "Song")
        query.whereKey("language", equalTo: language)
    
        query.findObjectsInBackgroundWithBlock{
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil
            {
                if let objects = objects as? [BabyTunes.Song] {
                    for (_, object) in objects.enumerate() {
                        self.tableCellsArray.append(object)
                    }
                }
                tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, tableView.numberOfSections)), withRowAnimation: .Automatic)
            }
            else
            {
                print("%@", error)
            }
        }
    }
    
}
