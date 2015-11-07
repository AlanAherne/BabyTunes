
//
//  BTViewController.swift
//  Sphere Menu
//
//  Created by Alan Aherne on 30/01/15.
//  Copyright (c) 2014 Camilo Morales. All rights reserved.
//

import UIKit
import Parse

enum Language : Int
{
    case ENGLAND, GERMANY, FRANCE, SPAIN

    static let languageNames = [ENGLAND : "english", GERMANY : "german", FRANCE : "french", SPAIN : "spanish"]
    static let languageMouseNames = [ENGLAND : "MouseDE", GERMANY : "MouseEN", FRANCE : "MouseFR", SPAIN : "MouseSP"]
    
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
        return UIImage(named: "Mouse\(languageName())")
    }
}

class BTViewController: UIViewController, SphereMenuDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var languageMouseImageView: UIImageView!
    
    var tableCellsArray: [Song] = []
    var menu : SphereMenu!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        if (self.tableView != nil)
        {
            self.tableView!.delegate = self
            self.tableView!.dataSource = self
        }
        
        let query = PFQuery(className: "Song")
        query.whereKey("language", equalTo: Language.GERMANY.languageName())
        
        query.findObjectsInBackgroundWithBlock{
            (objects: [PFObject]?, error: NSError?) -> Void in

            if error == nil
            {
                if let objects = objects as? [Song] {
                    for (_, object) in objects.enumerate() {
                        self.tableCellsArray.append(object)
                    }
                }
                self.tableView.reloadData()
            }
            else
            {
                print("%@", error)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.view.backgroundColor = UIColor(red:0.2, green:0.38, blue:0.8, alpha:1)
        let start = UIImage(named: "MouseStart")
        let image1 = Language.GERMANY.languageMouseCharacterIconImage()
        let image2 = Language.ENGLAND.languageMouseCharacterIconImage()
        let image3 = Language.FRANCE.languageMouseCharacterIconImage()
        let image4 = Language.SPAIN.languageMouseCharacterIconImage()
        let images:[UIImage] = [image1!,image2!,image3!,image4!]
        
        let bounds: CGRect = UIScreen.mainScreen().bounds
        let width:CGFloat = bounds.size.width
        let height:CGFloat = bounds.size.height
        
        menu = SphereMenu(startPoint: CGPointMake(width * 0.5, height - 50), startImage: start!, submenuImages:images)
        menu.delegate = self
        self.view.addSubview(menu)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("BTCell", forIndexPath: indexPath) as! BTCell
        
        let song = tableCellsArray[indexPath.row]
        
        cell.titleLabel.text = song.title
        cell.titleLabel.textColor = UIColor.whiteColor();
        cell.titleLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: 18)
        
        // Create a white border with defined width
        cell.cellImage!.layer.borderColor = UIColor.brownColor().CGColor
        cell.cellImage!.layer.borderWidth = 2.5
        
        // Set image corner radius
        cell.cellImage!.layer.cornerRadius = 5.0;
        
        cell.cellImage!.clipsToBounds = true
        
        song.imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            
            if let imageData = imageData where error == nil
            {
                cell.cellImage!.image = UIImage(data: imageData)
            }
        }

//        
//        let userImageFile = song.imageFile as PFFile
//        userImageFile.getDataInBackgroundWithBlock {
//            (imageData: NSData!, error: NSError!) -> Void in
//            if !error {
//                let image = UIImage(data:imageData)
//            }
//        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        SlideInCellAnimator.animate(cell)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        menu.shrinkSubmenu()
    }

    func sphereDidSelected(index: Int)
    {
        if let languageIndex = Language(rawValue : index)
        {
            //AA    self.languageMouseImageView.image = languageIndex.languageMouseCharacterImage()
            //AA    tableCellsArray = songsDict[languageIndex.languageName()]
            self.tableView.reloadData()
            
            let opts : UIViewAnimationOptions = .TransitionFlipFromLeft
            UIView.transitionWithView(self.languageMouseImageView, duration: 0.8, options: opts,
                animations: {
                    self.languageMouseImageView.image = languageIndex.languageMouseCharacterImage()
                }, completion: nil)
        }
    }
}

