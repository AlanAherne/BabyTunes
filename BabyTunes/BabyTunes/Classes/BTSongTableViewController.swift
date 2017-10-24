
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

class BTSongTableViewController: UIViewController, UICollectionViewDelegate, CircleMenuDelegate
{
    var cell_height:CGFloat!
    var dialLayout:AWCollectionViewDialLayout!
    
    @IBOutlet weak var popMenuView: PopCirCleMenuView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionViewDialLayout: UICollectionView!
    var dataSource : BTSongCollectionViewDataSource?
    
    // MARK: - View Management
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        if (self.collectionViewDialLayout != nil)
        {
            self.dataSource = BTSongCollectionViewDataSource()
            self.collectionViewDialLayout!.delegate = self
            self.collectionViewDialLayout!.dataSource = dataSource
        }
        
        self.dataSource!.loadSongsForLanguage(language: Language.germany.languageName())
        
        self.view.backgroundColor = UIColor(red:0.2, green:0.38, blue:0.8, alpha:1)
        
        popMenuView.circleButton?.delegate = self
        //Buttons count
        popMenuView.circleButton?.buttonsCount = 4
        
        //Distance between buttons and the red circle
        popMenuView.circleButton?.distance = 115
        
        //Delay between show buttons
        popMenuView.circleButton?.showDelay = 0.03
        
        //Animation Duration
        popMenuView.circleButton?.duration = 0.8
        
        guard let button = popMenuView.circleButton else {return}
        button.layer.cornerRadius = button.bounds.size.width / 2.0
        
        do{
            let radius = CGFloat(0.39 * 1000)
            let angularSpacing = CGFloat(0.16 * 90)
            let xOffset = CGFloat(0.23 * 320)
            let cell_width = CGFloat(240)
            cell_height = 100
            dialLayout = AWCollectionViewDialLayout(raduis: radius, angularSpacing: angularSpacing, cellSize: CGSize(width: cell_width, height: cell_height) , alignment: WheelAlignmentType.center, itemHeight: cell_height, xOffset: xOffset)
            dialLayout.shouldSnap = true
            dialLayout.shouldFlip = true
            collectionViewDialLayout.collectionViewLayout = dialLayout
            dialLayout.scrollDirection = .horizontal
            
            self.switchExample()
        }
    }
    func switchExample(){
        
        var radius:CGFloat = 0 ,angularSpacing:CGFloat  = 0, xOffset:CGFloat = 0
        dialLayout.cellSize = CGSize(width: 340, height: 100)
        dialLayout.wheelType = .left
        dialLayout.shouldFlip = false
            
        radius = 300
        angularSpacing = 18
        xOffset = 70
        
        dialLayout.dialRadius = radius
        dialLayout.angularSpacing = angularSpacing
        dialLayout.xOffset = xOffset
        
        collectionViewDialLayout.reloadData();
    }
    override func viewDidAppear(_ animated: Bool){
        
        super.viewDidAppear(animated)
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask{
        
        let orientation: UIInterfaceOrientationMask = [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
        return orientation
    }
    
    override func didReceiveMemoryWarning(){
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: CircleMenuButton, atIndex: Int) {
    
        if let language = Language(rawValue : atIndex)
        {
            //set color
            button.backgroundColor = UIColor.lightGray
            button.setImage(language.languageMouseCharacterImage(), for: UIControlState())
            button.layer.borderWidth = 5.0
            button.layer.borderColor = UIColor.white.cgColor
        
            // set highlited image
            let highlightedImage  = language.languageMouseCharacterImage()?.withRenderingMode(.alwaysTemplate)
            button.setImage(highlightedImage, for: .highlighted)
            button.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        
            //set text
            guard let textLabel = button.textLabel else {return}
            textLabel.text = language.languageName()
        }
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: CircleMenuButton, atIndex: Int) {
        print("button!!!!! will selected: \(atIndex)")
        
        /* Use this for the language/country change
         if let languageIndex = Language(rawValue : atIndex)
         {
         self.dataSource!.loadSongsForLanguage(language: languageIndex.languageName())
         }
 */
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: CircleMenuButton, atIndex: Int) {
        print("button!!!!! did selected: \(atIndex)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Select Item :: ", indexPath.item)
        //collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Top, animated: true)
    }
}

class BTSongCollectionViewDataSource: NSObject, UICollectionViewDataSource{
    
    // MARK: - BTSongTableViewDataSource
    let songsDict = ["english": ["Baa Baa Black Sheep", "Hush Little Baby", "Mary Had A Little Lamb", "The Animals Went In Two By Two", "Im A Little Teapot", "Old Mac Donald Had A Farm", "The Grand Old Duke Of York", "Hickory Dickory Dock", "Incy Wincy Spider", "Oranges And Lemons", "Three Blind Mice", "Humpty Dumpty", "London Bridge Is Falling Down", "Sing A Song Of Sixpence"],
                     "german": ["Alle Voegel sind schon da", "Ein Vogel wollte Hochzeit machen", "Kommt ein Vogel geflogen", "Auf einem Baum ein Kuckuck", "Der Mond ist aufgegangen", "Es klappert die Muehle", "Oh du lieber Augustin", "Backe backe Kuchen", "Die Gedanken sind frei", "Es tanzt ein Bi-Ba-Butzemann", "Spannenlanger Hansel", "Bruederchen komm tanz mit mir", "Ein Maennlein steht im Walde", "Haensel und Gretel", "Weisst du wieviel Sternlein stehen"],
                     "spanish": ["A mi burro", "El cocherito,lere", "La Tarara", "Anton Pirulero", "El patio de mi casa", "La reina Berenguela", "Tanto vestido blanco", "Cu-Cu, cantaba la rana", "Estando el senor don gato", "Los pollitos", "Tengo una muneca", "Debajo de un boton", "Jugando al escondite", "Quisiera ser tan alta",    "Tres hojitas, Madre"],
                     "french" : ["A la claire fontaine", "Cadet Rouselle", "Gentil coqulicot", "Le grand cerf", "Alouette, gentille alouette", "Cest Gugusse", "Il etait un petit navire", "Lempreur et le petit prince", "Arlequin danse sa boutique", "Compere Guilleri", "Jean de la Lune", "Maman, les ptits bateau", "Au claire de la lune", "Jean petit qui danse", "Savez - vous planter les choux"]]

    var collectionCellsArray: [Song] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionCellsArray.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell1", for: indexPath) as! AWCollectionCell
        
        cell.configure(collectionCellsArray[indexPath.row])
        return cell
    }
    
    // MARK: - Helpers
    func loadSongsForLanguage(language: String ){
        
        let dict = songsDict[language]
        self.collectionCellsArray.removeAll()
        
        for title in dict!{
            let song:Song = Song(fromLanguage: language, songTitle: title)
            self.collectionCellsArray.append(song)
        }
    }
    
}
