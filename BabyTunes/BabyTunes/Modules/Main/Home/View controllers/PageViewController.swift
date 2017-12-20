import UIKit
import RealmSwift

class PageViewController: UIPageViewController {
    
    let realm = try! Realm()
    lazy var songs: Results<Song> = { self.realm.objects(Song.self) }()
    
    var songsArray : [[(title: String, language: Language)]] = [[("Baa Baa Black Sheep", Language.england)], [("Hush Little Baby", Language.england)], [("Mary Had A Little Lamb", Language.england)], [("The Animals Went In Two By Two", Language.england)], [("Im A Little Teapot", Language.england)], [("Old Mac Donald Had A Farm", Language.england)], [("The Grand Old Duke Of York", Language.england)], [("Hickory Dickory Dock", Language.england)], [("Incy Wincy Spider", Language.england)], [("Oranges And Lemons", Language.england)], [("Three Blind Mice", Language.england)], [("Humpty Dumpty", Language.england)], [("London Bridge Is Falling Down", Language.england)], [("Sing A Song Of Sixpence", Language.england)],
                                                                [("Alle Voegel sind schon da", Language.germany)], [("Ein Vogel wollte Hochzeit machen", Language.germany)], [("Kommt ein Vogel geflogen", Language.germany)], [("Auf einem Baum ein Kuckuck", Language.germany)], [("Der Mond ist aufgegangen", Language.germany)], [("Es klappert die Muehle", Language.germany)], [("Oh du lieber Augustin", Language.germany)], [("Backe backe Kuchen", Language.germany)], [("Die Gedanken sind frei", Language.germany)], [("Es tanzt ein Bi-Ba-Butzemann", Language.germany)], [("Spannenlanger Hansel", Language.germany)], [("Bruederchen komm tanz mit mir", Language.germany)], [("Ein Maennlein steht im Walde", Language.germany)], [("Haensel und Gretel", Language.germany)], [("Weisst du wieviel Sternlein stehen", Language.germany)],
                                                                [("A mi burro", Language.spain)], [("El cocherito, lere", Language.spain)], [("La Tarara", Language.spain)], [("Anton Pirulero", Language.spain)], [("El patio de mi casa", Language.spain)], [("La reina Berenguela", Language.spain)], [("Tanto vestido blanco", Language.spain)], [("Cu-Cu, cantaba la rana", Language.spain)], [("Estando el senor don gato", Language.spain)], [("Los pollitos", Language.spain)], [("Tengo una muneca", Language.spain)], [("Debajo de un boton", Language.spain)], [("Jugando al escondite", Language.spain)], [("Quisiera ser tan alta", Language.spain)], [("Tres hojitas, Madre", Language.spain)],
                                                                [("A la claire fontaine", Language.france)], [("Cadet Rouselle", Language.france)], [("Gentil coqulicot", Language.france)], [("Le grand cerf", Language.france)], [("Alouette, gentille alouette", Language.france)], [("Cest Gugusse", Language.france)], [("Il etait un petit navire", Language.france)], [("Lempreur et le petit prince", Language.france)], [("Arlequin danse sa boutique", Language.france)], [("Compere Guilleri", Language.france)], [("Jean de la Lune", Language.france)], [("Maman, les ptits bateau", Language.france)], [("Au claire de la lune", Language.france)], [("Jean petit qui danse", Language.france)], [("Savez - vous planter les choux", Language.france)]
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = view
        dataSource = self
        populateDefaultSongs()
        setViewControllers([viewControllerForPage(at: 0)], direction: .forward, animated: false, completion: nil)
        
    }
    
    func populateDefaultSongs() {
        
        if songs.count == 0 {
            let freeSongs = ["Hickory Dickory Dock",
                             "The Animals Went In Two By Two",
                             "Es tanzt ein Bi-Ba-Butzemann",
                             "Haensel und Gretel",
                             "Cu-Cu, cantaba la rana",
                             "El patio de mi casa",
                             "Cest Gugusse",
                             "Le grand cerf"]
            try! realm.write() {
                
                for song in songsArray {
                    let newSong = Song()
                    newSong.language = song[0].language.rawValue
                    newSong.title = song[0].title
                    if  freeSongs.contains(newSong.title){
                        newSong.locked = false
                    }
                    self.realm.add(newSong)
                }
            }
            
            songs = realm.objects(Song.self)
            let a = songs[0]
            print("\(a.language)")
        }
    }
}

// MARK: Page view controller data source

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? CardViewController,
            let pageIndex = viewController.pageIndex,
            pageIndex > 0  else {
                return nil
        }
        return viewControllerForPage(at: pageIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? CardViewController,
            let pageIndex = viewController.pageIndex,
            pageIndex + 1 < songs.count else {
                return nil
        }
        return viewControllerForPage(at: pageIndex + 1)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return songs.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let viewControllers = pageViewController.viewControllers,
            let currentVC = viewControllers.first as? CardViewController,
            let currentPageIndex = currentVC.pageIndex else {
                return 0
        }
        return currentPageIndex
    }
    
    private func viewControllerForPage(at index: Int) -> UIViewController {
        let cardViewController: CardViewController = UIStoryboard(storyboard: .main).instantiateViewController()
        cardViewController.pageIndex = index
        
        var FIX_ME__🛠🛠🛠: AnyObject // Add guard for songName & key
        
        let pageSong = songs[index]
        cardViewController.song = pageSong
        return cardViewController
    }
}

