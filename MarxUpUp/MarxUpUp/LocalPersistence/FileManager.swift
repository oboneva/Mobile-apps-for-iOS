//
//  FileManager.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 27.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class FileManager: NSObject {

    static func getDataFromDefaultDocuments() -> [Data] {
        if let defaultDocuments = Bundle.main.urls(forResourcesWithExtension: "pdf", subdirectory: nil) {
            return defaultDocuments.map({ (url) -> Data in
                do {
                    let data = try Data(contentsOf: url)
                    return data
                }
                catch {
                    print("Error: Initializing data from url failed")
                    return Data()
                }
            }).filter({ !$0.isEmpty })
        }
        return [Data]()
    }
    
    static func getDataFromURL(_ url: URL) -> Data? {
        do {
            let data = try Data(contentsOf: url)
            return data
        }
        catch {
            print("Error: Initializing data from url failed")
        }
        return nil
    }
}
