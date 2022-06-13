//
//  main.swift
//  ColorsMatcher
//
//  Created by Alexey Salangin on 13.06.2022.
//

import Foundation


let colorsPath = #file.replacingOccurrences(of: "main.swift", with: "colors.json")
let url = URL(fileURLWithPath: colorsPath)
let json = try! Data(contentsOf: url)
let colors = try! JSONDecoder().decode([Color].self, from: json)

let uniqueColors = Set(colors)

let colorsWithInt = uniqueColors.filter { $0.intValues != nil }
let colorsWithoutInt = uniqueColors.filter { $0.intValues == nil }

print(colorsWithInt.map({ ($0.color, $0.intValues) }))
//print(colorsWithoutInt.map(\.color))

print("Colors with hex: \(colorsWithInt.count)")
print("Colors without hex: \(colorsWithoutInt.count)")
