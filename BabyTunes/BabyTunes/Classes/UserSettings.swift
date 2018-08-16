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

let englishExpirationDateKey = "EnglishExpirationDate"
let germanExpirationDateKey = "GermanExpirationDate"
let frenchExpirationDateKey = "FrenchExpirationDate"
let spanishExpirationDateKey = "SpanishExpirationDate"
let everythingExpirationDateKey = "EverythingExpirationDate"

class UserSettings {

    // MARK: - Properties
    static let shared = UserSettings()

    init() {
    }
    
    public var englishExpirationDate: Date? {
        set {
            UserDefaults.standard.set(newValue, forKey: englishExpirationDateKey)
        }
        get {
            return UserDefaults.standard.object(forKey: englishExpirationDateKey) as? Date
        }
    }
    
    public var germanExpirationDate: Date? {
        set {
            UserDefaults.standard.set(newValue, forKey: germanExpirationDateKey)
        }
        get {
            return UserDefaults.standard.object(forKey: germanExpirationDateKey) as? Date
        }
    }
    
    public var frenchExpirationDate: Date? {
        set {
            UserDefaults.standard.set(newValue, forKey: frenchExpirationDateKey)
        }
        get {
            return UserDefaults.standard.object(forKey: frenchExpirationDateKey) as? Date
        }
    }
    
    public var spanishExpirationDate: Date? {
        set {
            UserDefaults.standard.set(newValue, forKey: spanishExpirationDateKey)
        }
        get {
            return UserDefaults.standard.object(forKey: spanishExpirationDateKey) as? Date
        }
    }

    public var everythingExpirationDate: Date? {
        set {
            UserDefaults.standard.set(newValue, forKey: spanishExpirationDateKey)
        }
        get {
            return UserDefaults.standard.object(forKey: spanishExpirationDateKey) as? Date
        }
    }
    
    public func expirationDate(language : Language?) -> Date?{
        if language != nil{
            return UserDefaults.standard.object(forKey: language!.expirationDateKey()) as? Date
        }else{
            return UserDefaults.standard.object(forKey: "EverythingExpirationDate") as? Date
        }
    }

    public func setExpirationDate(newValue: Date?, language : Language?){
        if language != nil{
            UserDefaults.standard.set(newValue, forKey: (language?.expirationDateKey())!)
            
        }else{
            UserDefaults.standard.set(newValue, forKey: everythingExpirationDateKey)
        }
    }
    
    public func increaseEnglishExpirationDate(by months: Int) {
        let lastDate = englishExpirationDate ?? Date()
        let newDate = Calendar.current.date(byAdding: .month, value: months, to: lastDate)
        englishExpirationDate = newDate
    }
    
    public func increaseGermanExpirationDate(by months: Int) {
        let lastDate = germanExpirationDate ?? Date()
        let newDate = Calendar.current.date(byAdding: .month, value: months, to: lastDate)
        germanExpirationDate = newDate
    }
    
    public func increaseSpanishExpirationDate(by months: Int) {
        let lastDate = spanishExpirationDate ?? Date()
        let newDate = Calendar.current.date(byAdding: .month, value: months, to: lastDate)
        spanishExpirationDate = newDate
    }
    
    public func increaseFrenchExpirationDate(by months: Int) {
        let lastDate = frenchExpirationDate ?? Date()
        let newDate = Calendar.current.date(byAdding: .month, value: months, to: lastDate)
        frenchExpirationDate = newDate
    }
}
