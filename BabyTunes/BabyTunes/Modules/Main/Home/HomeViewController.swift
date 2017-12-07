
import UIKit
import ColorMatchTabs

class HomeViewContoller: ColorMatchTabsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.font = UIFont.navigationTitleFont()
        titleLabel.font = UIFont.navigationTitleFont()
        // to hide bottom button remove the following line
        popoverViewController = LanguagePopoverViewController()
        popoverViewController?.delegate = self
        dataSource = self
        reloadData()
    }
}

extension HomeViewContoller: ColorMatchTabsViewControllerDataSource {
    
    func numberOfItems(inController controller: ColorMatchTabsViewController) -> Int {
        return TabSwitcherItemsProvider.items.count
    }
    
    func tabsViewController(_ controller: ColorMatchTabsViewController, viewControllerAt index: Int) -> UIViewController {
        return StubContentViewControllersProvider.viewControllers[index]
    }
    
    func tabsViewController(_ controller: ColorMatchTabsViewController, titleAt index: Int) -> String {
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
}

extension HomeViewContoller: PopoverViewControllerDelegate {
    
    func popoverViewController(_ popoverViewController: PopoverViewController, didSelectItemAt index: Int) {
        selectItem(at: index)
    }
    
}
