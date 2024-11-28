//
//  count pages.swift
//  macos-count-pages
//
//  Created by Richard Martinez on 22/11/24.
//

import Foundation
import PDFKit

public func countPDFPages(url: URL) -> Int? {
    guard let pdfDocument = PDFDocument(url: url) else {
        print("Failed to load PDF: \(url.lastPathComponent)")
        return nil
    }
    return pdfDocument.pageCount
}

public func countDocxPages(url: URL) -> Int? {
    do {
        let zip = try ZipArchive(fileURL: url)
        guard let xmlData = zip.readFile(named: "docProps/app.xml") else {
            print("Failed to read docProps/app.xml for: \(url.lastPathComponent)")
            return nil
        }
        let parser = XMLPageCounter(xmlData: xmlData)
        return parser.pageCount
    } catch {
        print("Error processing DOCX file \(url.lastPathComponent): \(error)")
        return nil
    }
}


