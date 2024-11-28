//
//  ContentView.swift
//  macos-count-pages
//
//  Created by Richard Martinez on 18/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var pageData: [[String: Any]] = []
    @State private var droppedFiles: [URL] = []
    @State private var fileData: [[String: Any]] = []
    @State private var totalPages: Int = 0
    
    var body: some View {
        VStack {
            Image(systemName: "doc.on.doc")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            Divider()
            
            HStack(alignment: .top) {
            Text("Drag and drop .pdf and .docx files here")
                    .padding()
                    .frame(width: 300, height: 200)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .onDrop(of: [.fileURL], isTargeted: nil, perform: handleDrop)
                Divider()
                
                if !fileData.isEmpty {
                    List {
                        Section(header: Text("Total Pages")) {
                            Text("\(totalPages)")
                                .font(.headline)
                        }
                        Section(header: Text("File Details")) {
                            ForEach(fileData.indices, id: \.self) { index in
                                let item = fileData[index]
                                if let fileName = item.keys.first, let pageCount = item[fileName] as? Int {
                                    Text("\(fileName): \(pageCount) pages")
                                }
                            }
                        }
                    }
                } else {
                    Text("Only accepted .pdf and .docx files")
                        .padding()
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding()
            
            Divider()
            
            Spacer()
        }
        .frame(minWidth: 400, minHeight: 500)
        .padding()
    }
    
    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        fileData = []
        totalPages = 0
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier("public.file-url") {
                provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (item, error) in
                    if let data = item as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) {
                        DispatchQueue.main.async {
                            processFile(url: url)
                        }
                    }
                }
            }
        }
        return true
    }
    
    private func processFile(url: URL) {
        let fileExtension = url.pathExtension.lowercased()
        switch fileExtension {
        case "pdf":
            if let pageCount = countPDFPages(url: url) {
                appendFileData(fileName: url.lastPathComponent, pageCount: pageCount)
            }
        case "docx":
            if let pageCount = countDocxPages(url: url) {
                appendFileData(fileName: url.lastPathComponent, pageCount: pageCount)
            }
        default:
            print("Unsupported file type: \(url.lastPathComponent)")
        }
    }
    
    private func appendFileData(fileName: String, pageCount: Int) {
        fileData.append([fileName: pageCount])
        totalPages += pageCount
    }
}

#Preview {
    ContentView()
}
