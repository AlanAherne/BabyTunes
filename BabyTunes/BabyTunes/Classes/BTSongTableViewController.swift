
//
//  BTSongTableViewController.swift
//  BabyTunes
//
//  Created by Alan Aherne on 30/01/15.
//  Copyright (c) 2014 Alan Aherne. All rights reserved.
//
import UIKit

// MARK: - enums

enum Language : Int
{
    case england, germany, france, spain

    static let languageNames = [england : "english", germany : "german", france : "french", spain : "spanish"]
    static let languageMouseNames = [england : "MouseEN", germany : "MouseDE", france : "MouseFR", spain : "MouseSP"]
    
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
        
        self.dataSource!.loadSongsForLanguage(self.tableView, language: Language.germany.languageName())
        
        self.view.backgroundColor = UIColor(red:0.2, green:0.38, blue:0.8, alpha:1)
        
        var j: Int = 0
        var images:[UIImage] = []
        while let language = Language(rawValue: j) {
            
            let image = language.languageMouseCharacterIconImage()
            images.append(image!)
            j += 1
            if (j > 6) {break}
        }
        
        let bounds: CGRect = UIScreen.main.bounds
        let width:CGFloat = bounds.size.width
        let height:CGFloat = bounds.size.height
        
        menu = SphereMenu(startPoint: CGPoint(x: width * 0.5, y: height - 50), startImage: Language.germany.languageMouseCharacterIconImage(), submenuImages:images)
        menu.delegate = self
        self.view.addSubview(menu)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask
    {
        let orientation: UIInterfaceOrientationMask = [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
        return orientation
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UIScrollviewViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        menu.shrinkSubmenu()
    }
    
    // MARK: - SphereMenuDelegate
    
    func sphereDidSelected(_ index: Int)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        SlideInCellAnimator.animate(cell)
    }
}

// MARK: - BTSongTableViewDataSource
let songsDict = ["english": ["Baa Baa Black Sheep", "Hush Little Baby", "Mary Had A Little Lamb", "The Animals Went In Two By Two", "Im A Little Teapot", "Old Mac Donald Had A Farm", "The Grand Old Duke Of York", "Hickory Dickory Dock", "Incy Wincy Spider", "Oranges And Lemons", "Three Blind Mice", "Humpty Dumpty", "London Bridge Is Falling Down", "Sing A Song Of Sixpence"],
                 "german": ["Alle Voegel sind schon da", "Ein Vogel wollte Hochzeit machen", "Kommt ein Vogel geflogen", "Auf einem Baum ein Kuckuck", "Der Mond ist aufgegangen", "Es klappert die Muehle", "Oh du lieber Augustin", "Backe backe Kuchen", "Die Gedanken sind frei", "Es tanzt ein Bi-Ba-Butzemann", "Spannenlanger Hansel", "Bruederchen komm tanz mit mir", "Ein Maennlein steht im Walde", "Haensel und Gretel", "Weisst du wieviel Sternlein stehen"],
                 "spanish": ["A mi burro", "El cocherito,lere", "La Tarara", "Anton Pirulero", "El patio de mi casa", "La reina Berenguela", "Tanto vestido blanco", "Cu-Cu, cantaba la rana", "Estando el senor don gato", "Los pollitos", "Tengo una muneca", "Debajo de un boton", "Jugando al escondite", "Quisiera ser tan alta",	"Tres hojitas, Madre"],
                 "french" : ["A la claire fontaine", "Cadet Rouselle", "Gentil coqulicot", "Le grand cerf", "Alouette, gentille alouette", "Cest Gugusse", "Il etait un petit navire", "Lempreur et le petit prince", "Arlequin danse sa boutique", "Compere Guilleri", "Jean de la Lune", "Maman, les ptits bateau", "Au claire de la lune", "Jean petit qui danse", "Savez - vous planter les choux"]]

class BTSongTableViewDataSource: NSObject, UITableViewDataSource
{
    var tableCellsArray: [Song] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableCellsArray.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    {
        return 120
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BTSongTableCell", for: indexPath) as! BTSongTableCell
        cell.configure(tableCellsArray[indexPath.row])
        return cell
    }
    
    // MARK: - Helpers
    
    func loadSongsForLanguage(_ tableView: UITableView, language: String )
    {
        let dict = songsDict[language]
        self.tableCellsArray.removeAll()
        
        for title in dict!{
            let song:Song = Song(fromLanguage: language, songTitle: title)
            self.tableCellsArray.append(song)
        }
    }
}
