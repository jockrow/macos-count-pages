//
//  ContentView.swift
//  macos-count-pages
//
//  Created by Richard Martinez on 18/11/24.
//

import SwiftUI
import Foundation

//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            var message = "mi mensaje"
//            
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text(message)
//            
//            
////            Button("Apriétame").onSubmit {
////            }
//            
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ContentView()
//}
//


//struct ContentView: View {
//    @State private var lines: [String] = [] // Holds the Python script output
//    
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//                .padding(.bottom, 20)
//            
//            if lines.isEmpty {
//                Text("Running script...") // Show message while script executes
//                    .foregroundColor(.gray)
//            } else {
//                // Display script output as a list
//                List(lines, id: \.self) { line in
//                    Text(line)
//                }
//            }
//        }
//        .padding()
//        .onAppear {
//            runPythonScript()
//        }
//    }
//    
//    // Function to run the Python script and update `lines`
//    func runPythonScript() {
//        // Path to your Python script
////        let scriptPath = "~/devs/python/CountPdfPages - copia/countPdfPages.py"
//        let scriptPath = "--version"
//
//        // Create a Process to execute the Python script
//        let process = Process()
//        process.executableURL = URL(fileURLWithPath: "/opt/homebrew/bin/python3") // Path to Python 3
////        process.executableURL = URL(fileURLWithPath: "~/devs/python/CountPdfPages - copia/countenv/bin/python3") // Path to Python 3
//        process.arguments = [scriptPath]
//        
//        // Pipe to capture the script's output
//        let pipe = Pipe()
//        process.standardOutput = pipe
//        
//        DispatchQueue.global().async {
//            do {
//                // Run the process
//                try process.run()
//                process.waitUntilExit()
//                
//                // Read the output
//                let data = pipe.fileHandleForReading.readDataToEndOfFile()
//                if let output = String(data: data, encoding: .utf8) {
//                    // Split output into lines and update the state
//                    let outputLines = output.split(separator: "\n").map(String.init)
//                    DispatchQueue.main.async {
//                        self.lines = outputLines
//                    }
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.lines = ["Error: \(error.localizedDescription)"]
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}



struct ContentView: View {
    @State private var lines: [String] = [] // Holds the Python script output
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .padding(.bottom, 20)
            
            if lines.isEmpty {
                Text("Running script...") // Show message while script executes
                    .foregroundColor(.gray)
            } else {
                // Display script output as a list
                List(lines, id: \.self) { line in
                    Text(line)
                }
            }
        }
        .padding()
        .onAppear {
            runPythonScript()
        }
    }
    
    
    func shell(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.standardInput = nil
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    
    
    func runPythonScript() {
        // Resolve paths
        let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
        print("Home Path: \(homeDirectory)")
//        let pythonPath = "CountPdfPages/countenv/bin/python3"
//        let pythonPath = "~/Library/Containers/com.richard.macos-count-pages/Data/CountPdfPages/countenv/bin/python3"
//        let scriptPath = "~/Library/Containers/com.richard.macos-count-pages/Data/CountPdfPages/countPdfPages.py"

//        let pythonPath = "/opt/homebrew/bin/python3"
        let pythonPath = "/opt/homebrew/Cellar/python@3.11/3.11.9/bin"
//          let pythonPath = "ls -la"
//        let scriptPath = "--version"
//        let scriptPath = "CountPdfPages/countPdfPages.py"

//        let pythonPath = homeDirectory.appendingPathComponent("CountPdfPages/countenv/bin/python").path
        let scriptPath = homeDirectory.appendingPathComponent("CountPdfPages/countPdfPages.py").path
        
//      let pythonPath = "/bin/pwd"
//      let scriptPath = "-L"

        
//        // Log paths for debugging
       print("Python Path: \(pythonPath)")
       print("Script Path: \(scriptPath)")
        
//        let command = "\(pythonPath) \(scriptPath)"
//        print(command)
////        NSTask.run(pythonPath, scriptPath) //DON'T USE IT, CAUSE REPLACED BY Process
//        let r = shell(command)
////        let r = shell("\(pythonPath) --version")
//        print("command result: \(r)")


        // Create a Process to execute the Python script
        let process = Process()
        process.executableURL = URL(fileURLWithPath: pythonPath) // Path to Python interpreter
        process.arguments = [scriptPath]
        
        // Pipe to capture the script's output
        let pipe = Pipe()
        process.standardOutput = pipe
        
        DispatchQueue.global().async {
            do {
                // Run the process
                print("000")
                try process.run()
                print("111")
                process.waitUntilExit()
                print("222")

                // Read the output
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let output = String(data: data, encoding: .utf8) {
                    // Split output into lines and update the state
                    let outputLines = output.split(separator: "\n").map(String.init)
                    DispatchQueue.main.async {
                        self.lines = outputLines
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.lines = ["Error: \(error.localizedDescription)"]
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
