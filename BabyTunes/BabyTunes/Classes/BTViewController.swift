
//
//  BTViewController.swift
//  Sphere Menu
//
//  Created by Alan Aherne on 30/01/15.
//  Copyright (c) 2014 Camilo Morales. All rights reserved.
//

import UIKit

enum Language : Int {
    case ENGLAND, GERMANY, FRANCE, SPAIN

    static let languageNames = [ENGLAND : "England", GERMANY : "Germany", FRANCE : "France", SPAIN : "Spain"]
    static let languageMouseNames = [ENGLAND : "MouseDE", GERMANY : "MouseEN", FRANCE : "MouseFR", SPAIN : "MouseSP"]
    
    func languageName() -> String {
        if let languageName = Language.languageNames[self] {
            return languageName
        } else {
            return "language"
        }
    }
    
    func languageMouseName() -> String {
        if let languageMouseName = Language.languageMouseNames[self] {
            return languageMouseName
        } else {
            return "languageMouseName"
        }
    }
    
    func languageMouseCharacterIconImage() -> UIImage? {
        return UIImage(named: "\(languageMouseName())")!
    }
    
    func languageMouseCharacterImage() -> UIImage? {
        return UIImage(named: "Maus\(languageName())")!
    }
}

let songsDict = ["England": ["Baa Baa Black Sheep", "Hush Little Baby", "Mary Had A Little Lamb", "The Animals Went In Two By Two", "Im A Little Teapot", "Old Mac Donald Had A Farm", "The Grand Old Duke Of York", "Hickory Dickory Dock", "Incy Wincy Spider", "Oranges And Lemons", "Three Blind Mice", "Humpty Dumpty", "London Bridge Is Falling Down", "Sing A Song Of Sixpence"],
    "Germany": ["Alle Voegel sind schon da", "Ein Vogel wollte Hochzeit machen", "Kommt ein Vogel geflogen", "Auf einem Baum ein Kuckuck", "Der Mond ist aufgegangen", "Es klappert die Muehle", "Oh du lieber Augustin", "Backe backe Kuchen", "Die Gedanken sind frei", "Es tanzt ein Bi-Ba-Butzemann", "Spannenlanger Hansel", "Bruederchen komm tanz mit mir", "Ein Maennlein steht im Walde", "Haensel und Gretel", "Weisst du wieviel Sternlein stehen"],
    "Spain": ["A mi burro", "El cocherito,lere", "La Tarara", "Anton Pirulero", "El patio de mi casa", "La reina Berenguela", "Tanto vestido blanco", "Cu-Cu, cantaba la rana", "Estando el senor don gato", "Los pollitos", "Tengo una muneca", "Debajo de un boton", "Jugando al escondite", "Quisiera ser tan alta",	"Tres hojitas, Madre"],
    "France" : ["A la claire fontaine", "Cadet Rouselle", "Gentil coqulicot", "Le grand cerf", "Alouette, gentille alouette", "Cest Gugusse", "Il etait un petit navire", "Lempreur et le petit prince", "Arlequin danse sa boutique", "Compere Guilleri", "Jean de la Lune", "Maman, les ptits bateau", "Au claire de la lune", "Jean petit qui danse", "Savez - vous planter les choux"]]




class BTViewController: UIViewController, SphereMenuDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var languageMouseImageView: UIImageView!
    
    var tableCellsArray = songsDict[Language.GERMANY.languageName()]
    var menu : SphereMenu!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.tableView!.delegate = self;
        self.tableView!.dataSource = self;
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
        var images:[UIImage] = [image1!,image2!,image3!,image4!]
        
        var bounds: CGRect = UIScreen.mainScreen().bounds
        var width:CGFloat = bounds.size.width
        var height:CGFloat = bounds.size.height
        
        menu = SphereMenu(startPoint: CGPointMake(width * 0.5, height - 50), startImage: start!, submenuImages:images)
        menu.delegate = self
        self.view.addSubview(menu)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCellsArray!.count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BTCell", forIndexPath: indexPath) as BTCell
        
        cell.titleLabel.text = tableCellsArray![indexPath.row]
        cell.titleLabel.textColor = UIColor.whiteColor();
        cell.titleLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: 18)
        
        // Create a white border with defined width
        cell.cellImage!.layer.borderColor = UIColor.brownColor().CGColor
        cell.cellImage!.layer.borderWidth = 2.5
        
        // Set image corner radius
        cell.cellImage!.layer.cornerRadius = 5.0;
        
        cell.cellImage!.clipsToBounds = true
        
        cell.cellImage!.image = UIImage(named: "\(tableCellsArray![indexPath.row])_THM.png")

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
            tableCellsArray = songsDict[languageIndex.languageName()]
            self.tableView.reloadData()
            
            
            let opts : UIViewAnimationOptions = .TransitionFlipFromLeft
            UIView.transitionWithView(self.languageMouseImageView, duration: 0.8, options: opts,
                animations: {
                    self.languageMouseImageView.image = languageIndex.languageMouseCharacterImage()
                }, completion: nil)
        }
    }

    //    func listArray(index: Int) -> NSMutableArray
    //{
    //    return NSArray
    //}
}

