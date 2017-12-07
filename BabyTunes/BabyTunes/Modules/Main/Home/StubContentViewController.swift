//
//  StubContentViewController.swift
//  BabyTunes
//
//  Created by Alan Aherne on 03.11.17.
//  Copyright © 2017 CCDimensions. All rights reserved.
//

import UIKit

class StubContentViewController: UITableViewController {
    
    let songsDict = [Language.england: ["Baa Baa Black Sheep", "Hush Little Baby", "Mary Had A Little Lamb", "The Animals Went In Two By Two", "Im A Little Teapot", "Old Mac Donald Had A Farm", "The Grand Old Duke Of York", "Hickory Dickory Dock", "Incy Wincy Spider", "Oranges And Lemons", "Three Blind Mice", "Humpty Dumpty", "London Bridge Is Falling Down", "Sing A Song Of Sixpence"],
                     Language.germany: ["Alle Voegel sind schon da", "Ein Vogel wollte Hochzeit machen", "Kommt ein Vogel geflogen", "Auf einem Baum ein Kuckuck", "Der Mond ist aufgegangen", "Es klappert die Muehle", "Oh du lieber Augustin", "Backe backe Kuchen", "Die Gedanken sind frei", "Es tanzt ein Bi-Ba-Butzemann", "Spannenlanger Hansel", "Bruederchen komm tanz mit mir", "Ein Maennlein steht im Walde", "Haensel und Gretel", "Weisst du wieviel Sternlein stehen"],
                     Language.spain: ["A mi burro", "El cocherito, lere", "La Tarara", "Anton Pirulero", "El patio de mi casa", "La reina Berenguela", "Tanto vestido blanco", "Cu-Cu, cantaba la rana", "Estando el senor don gato", "Los pollitos", "Tengo una muneca", "Debajo de un boton", "Jugando al escondite", "Quisiera ser tan alta",    "Tres hojitas, Madre"],
                     Language.france : ["A la claire fontaine", "Cadet Rouselle", "Gentil coqulicot", "Le grand cerf", "Alouette, gentille alouette", "Cest Gugusse", "Il etait un petit navire", "Lempreur et le petit prince", "Arlequin danse sa boutique", "Compere Guilleri", "Jean de la Lune", "Maman, les ptits bateau", "Au claire de la lune", "Jean petit qui danse", "Savez - vous planter les choux"]] as [AnyHashable : [String]]

    var language: Language!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = UIColor.clear
        tableView.allowsSelection = false
        tableView.separatorColor = UIColor.red
        tableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songsDict[language]!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SongTableViewCell
        let dict = songsDict[language]
        
        guard (dict?.count)! > indexPath.row else{
            NSLog("Data error accured")
            return cell
        }
        let title = dict?[indexPath.row]
        NSLog("language : \(language.languageName()) - title : \(title) ")
        cell.apply(Song(fromLanguage: language.languageName(), songTitle: title!))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 419
    }
}
