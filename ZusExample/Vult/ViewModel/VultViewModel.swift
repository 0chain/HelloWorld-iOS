//
//  VultViewModel.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 28/12/22.
//

import Foundation
import Zcncore
import Combine
import _PhotosUI_SwiftUI

class VultViewModel: NSObject, ObservableObject {
    static var zboxAllocationHandle : ZboxAllocation? = nil
    
    @Published var allocation: Allocation = Allocation()
    @Published var presentAllocationDetails: Bool = false
    @Published var presentDocumentPicker: Bool = false

    @Published var files: Files = []
    @Published var selectedPhoto: PhotosPickerItem? = nil

    @Published var selectedFile: File? = nil
    @Published var openFile: Bool = false

    override init() {
        super.init()
        VultViewModel.zboxAllocationHandle = try? ZcncoreManager.zboxStorageSDKHandle?.getAllocation(Utils.get(key: .allocationID) as? String)
        self.getAllocation()
    }
    
    /// get allocation information from gosdk api
    func getAllocation()  {
        DispatchQueue.global().async {
            do {
                let decoder = JSONDecoder()
                
                guard let zboxAllocationHandle = VultViewModel.zboxAllocationHandle else { return }
                
                var allocation = Allocation()
                allocation.size = Int(zboxAllocationHandle.size)
                allocation.dataShards = zboxAllocationHandle.dataShards
                allocation.parityShards = zboxAllocationHandle.parityShards
                allocation.name = zboxAllocationHandle.name
                allocation.expirationDate = Int(zboxAllocationHandle.expiration)
                
                let allocationStats = zboxAllocationHandle.stats
                let allocationStatsData = Data(allocationStats.utf8)
                let allocationStatsModel = try decoder.decode(Allocation.self, from: allocationStatsData)

                allocation.addStats(allocationStatsModel)
                
                DispatchQueue.main.async {
                    self.allocation = allocation
                }
                
            } catch let error {
                print(error)
            }
        }
    }
    
    /// Upload images
    /// - Parameter selectedPhoto: selected image from photo picker
    func uploadImage(selectedPhoto: PhotosPickerItem?) {
        Task {
            do {
                guard let newItem = selectedPhoto else { return }
                let name = PHAsset.fetchAssets(withLocalIdentifiers: [newItem.itemIdentifier!], options: nil).firstObject?.value(forKey: "filename") as? String ?? ""
                if let data = try await newItem.loadTransferable(type: Data.self) {
                    try uploadFile(data: data, name: name)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func uploadDocument(result: Result<URL, Error>) {
        do {
            let url = try result.get()
            guard url.startAccessingSecurityScopedResource() else { return }
            let name = url.lastPathComponent
            let data = try Data(contentsOf: url)
            try uploadFile(data: data, name: name)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func uploadFile(data: Data, name: String) throws {
                
        var localPath = Utils.uploadPath.appendingPathComponent(name)
        var thumbnailPath =  Utils.downloadedThumbnailPath.appendingPathComponent(name)
        
        if let image = ZCNImage(data: data) {
            let pngData = image.pngData()
            try pngData?.write(to: localPath,options: .atomic)
            
            let thumbnailData = image.jpegData(compressionQuality: 0.1)
            try thumbnailData?.write(to: thumbnailPath)
        } else {
            try data.write(to: localPath,options: .atomic)
        }
        
        try VultViewModel.zboxAllocationHandle?.uploadFile(withThumbnail: Utils.tempPath(),
                                                           localPath: localPath.path,
                                                           remotePath: "/\(name)",
                                                           fileAttrs: nil,
                                                           thumbnailpath: thumbnailPath.path,
                                                           statusCb: self)
    }
    

    func downloadImage(file: File) {
        do {
            try VultViewModel.zboxAllocationHandle?.downloadFile(file.path,
                                                                 localPath: file.localFilePath.path,
                                                                 statusCb: self)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// get list of directory
    func listDir() {
        DispatchQueue.global().async {
            do {
                guard let allocation = VultViewModel.zboxAllocationHandle else { return }
                
                var error: NSError? = nil
                let jsonStr = allocation.listDir("/", error: &error)
                
                if let error = error { throw error }
                
                guard let data = jsonStr.data(using: .utf8) else { return }
                
                let files = try JSONDecoder().decode(Directory.self, from: data).list
                
                DispatchQueue.main.async {
                    self.files = files
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
}

extension VultViewModel: ZboxStatusCallbackMockedProtocol {
    /// commit meta completed
    /// - Parameters:
    ///   - request: request of file
    ///   - response: response of file
    ///   - err: error of Zbox
    func commitMetaCompleted(_ request: String?, response: String?, err: Error?) {
        
    }
    
    /// Allocation completed
    /// - Parameters:
    ///   - allocationId: allocationId of file
    ///   - filePath: filePath of file
    ///   - filename: filename of file
    ///   - mimetype: mimetype of file
    ///   - size: size of file
    ///   - op: transaction operation code
    func completed(_ allocationId: String?, filePath: String?, filename: String?, mimetype: String?, size: Int, op: Int) {
        print("completed \(filePath) \(size.formattedByteCount)")
        DispatchQueue.main.async {
            if let index = self.files.firstIndex(where: {$0.path == filePath}) {
                self.files[index].completedBytes = size
                self.files[index].status = .completed
                if op == 0 {
                    self.files[index].isUploaded = true
                }
            }
        }
        DispatchQueue.main.async {
            self.allocation.addSize(size)
        }
    }
    
    /// Allocation failed
    /// - Parameters:
    ///   - allocationID: allocationId of file
    ///   - filePath: filePath of file
    ///   - op: transaction operation code
    ///   - err: error of file
    func error(_ allocationID: String?, filePath: String?, op: Int, err: Error?) {
        print("error \(filePath) \(err?.localizedDescription)")
        DispatchQueue.main.async {
            if let index = self.files.firstIndex(where: {$0.path == filePath}) {
                self.files[index].status = .error
            }
        }
    }
    
    /// Allocation inProgress
    /// - Parameters:
    ///   - allocationId: allocationId of file
    ///   - filePath: filePath of file
    ///   - op: transaction operation code
    ///   - completedBytes: completedBytes of file
    ///   - data: data of file
    func inProgress(_ allocationId: String?, filePath: String?, op: Int, completedBytes: Int, data: Data?) {
        print("inProgress \(filePath) \(completedBytes.formattedByteCount)")
        DispatchQueue.main.async {
            if let index = self.files.firstIndex(where: {$0.path == filePath}) {
                self.files[index].completedBytes = completedBytes
                self.files[index].status = .progress
                self.objectWillChange.send()
            } else {
                var file = File()
                file.path = filePath ?? ""
                file.name = filePath?.replacingOccurrences(of: "/", with: "") ?? ""
                file.completedBytes = completedBytes
                file.status = .progress
                file.isUploaded = false
                DispatchQueue.main.async {
                    self.files.append(file)
                }
            }
        }
    }
    
    /// Allocation repair completed
    /// - Parameter filesRepaired: Repaired of file
    func repairCompleted(_ filesRepaired: Int) {
        
    }
    
    /// Allocation stared
    /// - Parameters:
    ///   - allocationId: allocationId of file
    ///   - filePath: filePath of file
    ///   - op: transaction operation code
    ///   - totalBytes: totalBytes of file
    func started(_ allocationId: String?, filePath: String?, op: Int, totalBytes: Int) {
        print("started \(filePath) \(totalBytes.formattedByteCount)")
        if op == 0 {
            var file = File()
            file.path = filePath ?? ""
            file.name = filePath?.replacingOccurrences(of: "/", with: "") ?? ""
            file.size = totalBytes
            file.completedBytes = 0
            file.status = .progress
            file.isUploaded = false
            DispatchQueue.main.async {
                self.files.insert(file, at: 0)
            }
        }
    }
    
}
