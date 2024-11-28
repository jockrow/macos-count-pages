//
//  XMLPageCounter.swift
//  macos-count-pages
//
//  Created by Richard Martinez on 27/11/24.
//
import Foundation

class XMLPageCounter {
    private let xmlData: Data

    init(xmlData: Data) {
        self.xmlData = xmlData
    }

    var pageCount: Int? {
        guard let xmlDoc = try? XMLDocument(data: xmlData) else {
            return nil
        }
        let pagesNode = xmlDoc.rootElement()?.elements(forName: "Pages").first
        return Int(pagesNode?.stringValue ?? "")
    }
}
