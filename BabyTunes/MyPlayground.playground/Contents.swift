//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


var songsArray : [[(title: String, language: Int)]] = [[("Baa Baa Black Sheep", 1)], [("Hush Little Baby", 2)]]
var song = songsArray[1]
print("\(song[0].title)")
