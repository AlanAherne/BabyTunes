/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import Parse

public struct BabyTunesProducts {

  // MARK: - Properties
  static let PurchaseNotification = "BabyTunesProductsPurchaseNotification"
  
  static let randomProductID = "com.cyrstalcleardimensions.BabyTunes.RandomOwls"
  static let productIDsConsumables: Set<ProductIdentifier> = [randomProductID]
  static let productIDsNonRenewing: Set<ProductIdentifier> = ["com.cyrstalcleardimensions.BabyTunes.3monthsOfEverything",
                                                              "com.cyrstalcleardimensions.BabyTunes.6monthsOfEverything",
                                                              "com.cyrstalcleardimensions.BabyTunes.12monthsOfEverything"]
  static let freeSongs = ["Hickory Dickory Dock",
                     "The Animals Went In Two By Two",
                     "Es tanzt ein Bi-Ba-Butzemann",
                     "Haensel und Gretel",
                     "Cu-Cu, cantaba la rana",
                     "El patio de mi casa",
                     "Cest Gugusse",
                     "Le grand cerf"]
  
  static let productIDsNonConsumables: Set<ProductIdentifier> = [
    "com.cyrstalcleardimensions.BabyTunes.GoodJobOwl",
    "com.cyrstalcleardimensions.BabyTunes.CouchOwl",
    "com.cyrstalcleardimensions.BabyTunes.CarefreeOwl",
    "com.cyrstalcleardimensions.BabyTunes.NightOwl",
    "com.cyrstalcleardimensions.BabyTunes.LonelyOwl",
    "com.cyrstalcleardimensions.BabyTunes.ShyOwl",
    "com.cyrstalcleardimensions.BabyTunes.CryingOwl",
    "com.cyrstalcleardimensions.BabyTunes.GoodNightOwl",
    "com.cyrstalcleardimensions.BabyTunes.InLoveOwl"
  ]
  
  public static let store = IAPHelper(productIds: BabyTunesProducts.productIDsConsumables
    .union(BabyTunesProducts.productIDsNonConsumables)
    .union(BabyTunesProducts.productIDsNonRenewing))
  
  public static func resourceName(for productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
  }

  public static func clearProducts() {
    store.purchasedProducts.removeAll()
  }

  public static func handlePurchase(productID: String) {
    if productIDsNonRenewing.contains(productID), productID.contains("3months") {
      handleMonthlySubscription(months: 3)
    } else if productIDsNonRenewing.contains(productID), productID.contains("6months") {
      handleMonthlySubscription(months: 6)
    } else if productIDsNonRenewing.contains(productID), productID.contains("12months") {
        handleMonthlySubscription(months: 12)
    }else if productIDsNonConsumables.contains(productID) {
      UserDefaults.standard.set(true, forKey: productID)
      store.purchasedProducts.insert(productID)
      
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: PurchaseNotification),
                                      object: nil)
    }
  }
  
  public static func setRandomProduct(with paidUp: Bool) {
    if paidUp {
      UserDefaults.standard.set(true, forKey: BabyTunesProducts.randomProductID)
      store.purchasedProducts.insert(BabyTunesProducts.randomProductID)
    } else {
      UserDefaults.standard.set(false, forKey: BabyTunesProducts.randomProductID)
      store.purchasedProducts.remove(BabyTunesProducts.randomProductID)
    }
  }
  
  public static func daysRemainingOnSubscription() -> Int {
    if let expiryDate = UserSettings.shared.expirationDate {
      return Calendar.current.dateComponents([.day], from: Date(), to: expiryDate).day!
    }
    return 0
  }
  
  public static func getExpiryDateString() -> String {
    let remaining = daysRemainingOnSubscription()
    if remaining > 0, let expiryDate = UserSettings.shared.expirationDate {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd/MM/yyyy"
      return "Subscribed! \nExpires: \(dateFormatter.string(from: expiryDate)) (\(remaining) Days)"
    }
    return "Not Subscribed"
  }
  
  public static func paidUp() -> Bool {
    var paidUp = false
    if BabyTunesProducts.daysRemainingOnSubscription() > 0 {
      paidUp = true
    } else if UserSettings.shared.randomRemaining > 0 {
      paidUp = true
    }
    setRandomProduct(with: paidUp)
    return paidUp
  }
  
  public static func syncExpiration(local: Date?, completion: @escaping (_ object: PFObject?) -> ()) {
    // Query Parse for expiration date.
    
    guard let user = PFUser.current(),
      let userID = user.objectId,
      user.isAuthenticated else {
        return
    }
    
    let query = PFQuery(className: "_User")
    query.getObjectInBackground(withId: userID) {
      object, error in
      
      let parseExpiration = object?[expirationDateKey] as? Date
      
      // Get to latest date between Parse and local.
      var latestDate: Date?
      if parseExpiration == nil {
        latestDate = local
      } else if local == nil {
        latestDate = parseExpiration
      } else if parseExpiration!.compare(local!) == .orderedDescending {
        latestDate = parseExpiration
      } else {
        latestDate = local
      }
      
      if let latestDate = latestDate {
        // Update local
        UserSettings.shared.expirationDate = latestDate
        
        // See if subscription valid
        if latestDate.compare(Date()) == .orderedDescending {
          setRandomProduct(with: true)
        }
      }
      
      completion(object)
    }
  }
  
  private static func handleMonthlySubscription(months: Int) {
    // Update local and Parse with new subscription.
    
    syncExpiration(local: UserSettings.shared.expirationDate) {
      object in
      
      // Increase local
      UserSettings.shared.increaseRandomExpirationDate(by: months)
      setRandomProduct(with: true)
      
      // Update Parse with extended purchase
      object?[expirationDateKey] = UserSettings.shared.expirationDate
      object?.saveInBackground()
      
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: PurchaseNotification),
                                      object: nil)
    }
  }
}
