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

enum ProductsIdentifier: ProductIdentifier {
    
    case subscriptionEverything = "com.cyrstalcleardimensions.BabyTunes.3monthsOfEverything"
    case subscriptionEnglish = "com.cyrstalcleardimensions.BabyTunes.3monthsOfEnglish"
    case subscriptionGerman = "com.cyrstalcleardimensions.BabyTunes.3monthsOfGerman"
    case subscriptionFrench = "com.cyrstalcleardimensions.BabyTunes.3monthsOfFrench"
    case subscriptionSpanish = "com.cyrstalcleardimensions.BabyTunes.3monthsOfSpanish"
}

public struct BabyTunesProducts {
    
    // MARK: - Properties
    static let PurchaseNotification = "BabyTunesProductsPurchaseNotification"
  
    static let productIDsNonRenewing: Set<ProductIdentifier> = [ProductsIdentifier.subscriptionEverything.rawValue,
                                                                ProductsIdentifier.subscriptionEnglish.rawValue,
                                                                ProductsIdentifier.subscriptionGerman.rawValue,
                                                                ProductsIdentifier.subscriptionFrench.rawValue,
                                                                ProductsIdentifier.subscriptionSpanish.rawValue]
    
    static let freeSongs = ["Hickory Dickory Dock",
                            "The Animals Went In Two By Two",
                            "Es tanzt ein Bi-Ba-Butzemann",
                            "Haensel und Gretel",
                            "Cu-Cu, cantaba la rana",
                            "El patio de mi casa",
                            "Cest Gugusse",
                            "Le grand cerf"]
    
    public static let store = IAPHelper(productIds: BabyTunesProducts.productIDsNonRenewing)
  
    public static func resourceName(for productIdentifier: String) -> String? {
        return productIdentifier.components(separatedBy: ".").last
    }

    public static func clearProducts() {
        store.purchasedProducts.removeAll()
    }

    public static func handlePurchase(productID: String) {
        if productIDsNonRenewing.contains(productID), productID.contains("3months") {
            if  productID.contains("Everything"){
                handleMonthlySubscription(months: 3, language: Language.england)
                handleMonthlySubscription(months: 3, language: Language.germany)
                handleMonthlySubscription(months: 3, language: Language.france)
                handleMonthlySubscription(months: 3, language: Language.spain)
            }
            if  productID.contains("English"){
                handleMonthlySubscription(months: 3, language: Language.england)
            }else if  productID.contains("German"){
                handleMonthlySubscription(months: 3, language: Language.germany)
            }else if  productID.contains("French"){
                handleMonthlySubscription(months: 3, language: Language.france)
            }else if  productID.contains("Spanish"){
                handleMonthlySubscription(months: 3, language: Language.spain)
            }
        }
    }
  
    static func daysRemainingOnSubscription(identifier: ProductsIdentifier) -> Int {
        var expiryDate : Date?
        switch identifier{
        case .subscriptionEnglish:
            expiryDate = UserSettings.shared.englishExpirationDate
        case .subscriptionGerman:
            expiryDate = UserSettings.shared.germanExpirationDate
        case .subscriptionFrench:
            expiryDate = UserSettings.shared.frenchExpirationDate
        case .subscriptionSpanish:
            expiryDate = UserSettings.shared.spanishExpirationDate
        default:
            expiryDate = UserSettings.shared.everythingExpirationDate
        }
        
        guard let date = expiryDate else {
            return 0
        }
        return Calendar.current.dateComponents([.day], from: Date(), to: date).day!
    }
  
    static func syncExpiration(local: Date?, language: Language?, completion: @escaping (_ object: PFObject?) -> ()) {
    // Query Parse for expiration date.
    
        guard let user = PFUser.current(), let userID = user.objectId, user.isAuthenticated else {
            return
        }
    
        let query = PFQuery(className: "_User")
        query.getObjectInBackground(withId: userID) {
            object, error in
      
            let expirationDateKey = language != nil ? language?.expirationDateKey() : everythingExpirationDateKey
            let parseExpiration = object?[expirationDateKey!] as? Date
      
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
                UserSettings.shared.setExpirationDate(newValue: latestDate, language : language)
            }
      
            completion(object)
        }
    }
  
    private static func handleMonthlySubscription(months: Int, language: Language?) {
        // Update local and Parse with new subscription.
    
        syncExpiration(local: UserSettings.shared.expirationDate(language : language), language: language) {
            [language] object in
      
            // Update Parse with extended purchase
            let expirationDateKey = language != nil ? language?.expirationDateKey() : everythingExpirationDateKey
            object?[expirationDateKey!] = UserSettings.shared.expirationDate(language : language)
            object?.saveInBackground()
      
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: PurchaseNotification), object: nil)
        }
    }
}
