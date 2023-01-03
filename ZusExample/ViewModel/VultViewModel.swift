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
    @Published var selectedDocument: URL? = nil

    @Published var selectedFile: File? = nil
    @Published var openFile: Bool = false

    override init() {
        super.init()
        VultViewModel.zboxAllocationHandle = try? ZcncoreManager.zboxStorageSDKHandle?.getAllocation(Utils.get(key: .allocationID) as? String)
        self.getAllocation()
    }
    
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
    
    func uploadImage(selectedPhoto: PhotosPickerItem?) {
        Task {
            do {
                guard let newItem = selectedPhoto else { return }
                let name = PHAsset.fetchAssets(withLocalIdentifiers: [newItem.itemIdentifier!], options: nil).firstObject?.value(forKey: "filename") as? String ?? ""
                let data = try await newItem.loadTransferable(type: Data.self)
                let localPath = Utils.uploadPath.appendingPathComponent(name)
                let thumbnailPath =  Utils.downloadedThumbnailPath.appendingPathComponent(name)
                
                if let data = data, let image = ZCNImage(data: data) {
                    let pngData = image.pngData()
                    try pngData?.write(to: localPath,options: .atomic)
                    
                    let thumbnailData = image.jpegData(compressionQuality: 0.1)
                    try thumbnailData?.write(to: thumbnailPath)
                    
                    try VultViewModel.zboxAllocationHandle?.uploadFile(withThumbnail: Utils.tempPath(),
                                                                       localPath: localPath.path,
                                                                       remotePath: "/\(name)",
                                                                       fileAttrs: nil,
                                                                       thumbnailpath: thumbnailPath.path,
                                                                       statusCb: self)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func uploadDocument(url: URL?) {
        Task {
            do {
                guard let url = url else { return }
                guard url.startAccessingSecurityScopedResource() else { return }
                
                let name = url.lastPathComponent
                
                let localPath = Utils.uploadPath.appendingPathComponent(name)
                let thumbnailPath =  Utils.downloadedThumbnailPath.appendingPathComponent(name)
                
                let data = try Data(contentsOf: url)
                let image = ZCNImage(data: data)
                let pngData = image?.pngData()
                try pngData?.write(to: localPath,options: .atomic)
                
                let thumbnailData = image?.jpegData(compressionQuality: 0.1)
                try thumbnailData?.write(to: thumbnailPath)
                
                try VultViewModel.zboxAllocationHandle?.uploadFile(withThumbnail: Utils.tempPath(),
                                                                   localPath: localPath.path,
                                                                   remotePath: "/\(name)",
                                                                   fileAttrs: nil,
                                                                   thumbnailpath: thumbnailPath.path,
                                                                   statusCb: self)
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
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
    
    func listDir() {
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

extension VultViewModel: ZboxStatusCallbackMockedProtocol {
    func commitMetaCompleted(_ request: String?, response: String?, err: Error?) {
        
    }
    
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
        self.getAllocation()
    }
    
    func error(_ allocationID: String?, filePath: String?, op: Int, err: Error?) {
        print("error \(filePath) \(err?.localizedDescription)")
        DispatchQueue.main.async {
            if let index = self.files.firstIndex(where: {$0.path == filePath}) {
                self.files[index].status = .error
            }
        }
    }
    
    func inProgress(_ allocationId: String?, filePath: String?, op: Int, completedBytes: Int, data: Data?) {
        print("inProgress \(filePath) \(completedBytes.formattedByteCount)")
        DispatchQueue.main.async {
            if let index = self.files.firstIndex(where: {$0.path == filePath}) {
                self.files[index].completedBytes = completedBytes
                self.files[index].status = .progress
            }
        }
    }
    
    func repairCompleted(_ filesRepaired: Int) {
        
    }
    
    func started(_ allocationId: String?, filePath: String?, op: Int, totalBytes: Int) {
        print("started \(filePath) \(totalBytes.formattedByteCount)")
        if op == 0 {
            let file = File()
            file.path = filePath ?? ""
            file.name = filePath?.replacingOccurrences(of: "/", with: "") ?? ""
            file.size = totalBytes
            file.completedBytes = 0
            file.status = .progress
            file.isUploaded = false
            DispatchQueue.main.async {
                self.files.append(file)
            }
        }
    }
    
}
