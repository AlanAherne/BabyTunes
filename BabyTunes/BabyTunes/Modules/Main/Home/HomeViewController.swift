
import UIKit
import ColorMatchTabs

class HomeViewContoller: ColorMatchTabsViewController, CircleMenuDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _  = self.view
        
        titleLabel.font = UIFont.navigationTitleFont()
        
        dataSource = self
        reloadData()
/*
        self.popMenuView.circleButton?.delegate = self
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
 */
    }
/*
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
 */
}

extension HomeViewContoller: ColorMatchTabsViewControllerDataSource {
    
    func numberOfItems(inController controller: ColorMatchTabsViewController) -> Int {
        return TabSwitcherItemsProvider.items.count
    }
    
    func tabsViewController(_ controller: ColorMatchTabsViewController, viewControllerAt index: Int) -> UIViewController {
        return StubContentViewControllersProvider.viewControllers[index]
    }
    
    func tabsViewController(_ controller: ColorMatchTabsViewController, titleAt index: Int) -> String {
        print("TabSwitcherItemsProvider.items[index].title -> \(TabSwitcherItemsProvider.items[index].title)")
        return TabSwitcherItemsProvider.items[index].title
    }
    
    func tabsViewController(_ controller: ColorMatchTabsViewController, iconAt index: Int) -> UIImage {
        return TabSwitcherItemsProvider.items[index].normalImage
    }
    
    func tabsViewController(_ controller: ColorMatchTabsViewController, hightlightedIconAt index: Int) -> UIImage {
        return TabSwitcherItemsProvider.items[index].highlightedImage
    }
    
    func tabsViewController(_ controller: ColorMatchTabsViewController, tintColorAt index: Int) -> UIColor {
        return TabSwitcherItemsProvider.items[index].tintColor
    }
    
}

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
