//
//  ZipArchive.swift
//  macos-count-pages
//
//  Created by Richard Martinez on 27/11/24.
//
import Foundation
import ZIPFoundation

class ZipArchive {
    private let fileURL: URL

    init(fileURL: URL) throws {
        self.fileURL = fileURL
    }

    func readFile(named fileName: String) -> Data? {
        do {
            let archive = try Archive(url: fileURL, accessMode: .read) // Updated to handle the throwing initializer
            guard let entry = archive[fileName] else {
                print("File \(fileName) not found in archive.")
                return nil
            }
    
            var data = Data()
            do {
                _ = try archive.extract(entry) { extractedData in
                    data.append(extractedData)
                }
                return data
            } catch {
                print("Failed to extract \(fileName) from archive: \(error)")
                return nil
            }
        } catch {
            print("Failed to open ZIP archive: \(fileURL.lastPathComponent), error: \(error)")
            return nil
        }
    }
}
