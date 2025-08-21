//
//  FileLoader.swift
//  Tools PoC
//
//  Created by RAJESH MURALIDHARAN on 8/8/25.
//

import Foundation

class FileLoader {
    static func loadFile(at path: String) throws -> Data {
        return try Data(contentsOf: URL(fileURLWithPath: path))
    }
    
    static func loadBundleFile(named name: String, withExtension: String?) throws -> Data {
        return try Data(contentsOf: Bundle.main.url(forResource: name, withExtension: withExtension)!)
    }
}
