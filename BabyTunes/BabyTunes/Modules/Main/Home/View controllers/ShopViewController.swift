
import UIKit
import Parse
import StoreKit

class ShopViewController: UIViewController {

  // MARK: - IBOutlets
  @IBOutlet weak var tableView: UITableView!

  // MARK: - Properties
  let showDetailSegueIdentifier = "showDetail"
  let randomImageSegueIdentifier = "randomImage"
  var products: [SKProduct] = []
  let refreshControl = UIRefreshControl()

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    refreshControl.addTarget(self, action: #selector(requestAllProducts), for: .valueChanged)
    tableView.addSubview(refreshControl)
    refreshControl.beginRefreshing()
    requestAllProducts()

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handlePurchaseNotification),
                                           name: NSNotification.Name(rawValue: BabyTunesProducts.PurchaseNotification),
                                           object: nil)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    if let user = PFUser.current(),
      user.isAuthenticated {
        navigationItem.leftBarButtonItem?.title = "Sign Out"
    } else {
      navigationItem.leftBarButtonItem?.title = "Sign In"
    }

    tableView.reloadData()
  }

  func signOutTapped() {
    PFUser.logOut()
    BabyTunesProducts.clearProducts()
    _ = navigationController?.popViewController(animated: true)
  }
    
    @objc func requestAllProducts() {
        BabyTunesProducts.store.requestProducts { [unowned self] success, products in
            if success,
                let products = products {
                self.products = products
                self.tableView.reloadData()
            }

            self.refreshControl.endRefreshing()
        }
    }

  @IBAction func restoreTapped(_ sender: AnyObject) {
    // Restore Consumables from Apple
    BabyTunesProducts.store.restorePurchases()
    
    // Restore Non-Renewing Subscriptions Date saved in Parse
    BabyTunesProducts.syncExpiration(local: UserSettings.shared.expirationDate) {
      object in
      
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }

    @objc func handlePurchaseNotification(_ notification: Notification) {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
}

// MARK: - UITableViewDataSource
extension ShopViewController: UITableViewDataSource {

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellProduct", for: indexPath) as! ProductCell

        let product = products[(indexPath as NSIndexPath).row]
        cell.product = product
        cell.buyButtonHandler = { product in
            BabyTunesProducts.store.buyProduct(product)
        }

    return cell
  }
}
