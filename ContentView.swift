
import SwiftUI
import _RealityKit_SwiftUI

import RealityKitContent

struct ContentView: View {
    
    // Array to store model names
    @State private var modelNames: [String] = []
    
    // State variable to store the selected file index
    @State private var selectedFileIndex = "images_medium"
    
    @State private var selectedNumber = 1
    let numbers = Array(1...10)
    
    @State var entity: Entity? = nil
    @State var showFilePicker: Bool = false
    
    
    var body: some View {
        
        RealityView(
            make: { content in
                // Add a placeholder entity to parent the entity to.
                //
                let placeholderEntity = Entity()
                placeholderEntity.name = "$__placeholder"
                
                if let loadedEntity = self.entity {
                    placeholderEntity.addChild(loadedEntity)
                }
                
                content.add(placeholderEntity)
            },
            update: { content in
                guard let placeholderEntity = content.entities.first(where: {
                    $0.name == "$__placeholder"
                }) else {
                    preconditionFailure("Unable to find placeholder entity")
                }
                
                // If there is a loaded entity, remove the old child,
                // and add the new one.
                //
                if let loadedEntity = self.entity {
                    placeholderEntity.children.removeAll()
                    placeholderEntity.addChild(loadedEntity)
                }
            }
        )
        
        Button(
            action: {
                showFilePicker.toggle()
            },
            label: {
                Text("Load USDZ")
            }
        ).padding()
        
            .fileImporter(isPresented: $showFilePicker, allowedContentTypes: [.usdz]) { result in
            // Get the URL of the USDZ picked by the user.
            //
            guard let url = try? result.get() else {
                print("Unable to get URL")
                return
            }

            Task {
                // As the app is sandboxed, permission needs to be
                // requested to access the file, as it's outside of
                // the sandbox.
                //
                if url.startAccessingSecurityScopedResource() {
                    defer {
                        url.stopAccessingSecurityScopedResource()
                    }
                    
                    // Load the USDZ asynchronously.
                    //
                    self.entity = try await Entity(contentsOf: url)
                }
            }
        }
        
        
        
        
        
        let files = fetchModelNames()
        
        Picker("Select Number", selection: $selectedNumber) {
            ForEach(numbers, id: \.self) { number in
                Text("\(number)")
                    .font(.system(size: 100))
            }
            .scaleEffect(3)
        }
        .padding()
//        .onChange(of: selectedNumber) {
//            print(selectedNumber)
//            if selectedNumber >= 0 && selectedNumber < files.count {
//                print("Selected File: \(files[selectedNumber])")
//            } else {
////                print("Out of bounds File: \(files[selectedNumber])")
////                print("Out of bounds File: \(files[selectedNumber])")
////                print("Total files: \(files.count)")
//
//            }
////            print($selectedNumber)
//        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // Function to fetch model names from a directory
    func fetchModelNames() -> [String] {
        // Path to the directory containing models
//        let fm = FileManager.default
//        let path = "/Users/zachmizrachi/Desktop/DisplayUSDZ/Packages/RealityKitContent/Sources/RealityKitContent/RealityKitContent.rkassets"
        var usdzFiles: [String] = []
//        
//
//        
//        do {
//            let items = try fm.contentsOfDirectory(atPath: path)
//            
//            // Filter only files with .usdz extension
//            usdzFiles = items.filter { $0.hasSuffix(".usdz") }
//        } catch {
//            // failed to read directory – bad permissions, perhaps?
//            print("Error reading directory:", error.localizedDescription)
//        }
        
        
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let mainBundle = Bundle.main

        let docDir = getDocumentsDirectory()
        print("Looking here: ")
        print(mainBundle)

       
        
        let url = URL(fileURLWithPath: "/Users/zachmizrachi/Desktop/DisplayUSDZ/Packages/RealityKitContent/Sources/RealityKitContent/RealityKitContent.rkassets/")
        let entity = try? Entity.load(contentsOf: url)
        
        return usdzFiles
    }
    
}



   

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

