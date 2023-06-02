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
import ZCNSwift

class VultViewModel: NSObject, ObservableObject {
    static var zboxAllocationHandle : ZboxAllocation? = nil
    
    @Published var allocation: Allocation = Allocation.default
    
    @Published var presentAllocationDetails: Bool = false
    @Published var presentDocumentPicker: Bool = false

    @Published var files: Files = []
    @Published var selectedPhoto: PhotosPickerItem? = nil

    @Published var selectedFile: File? = nil
    @Published var openFile: Bool = false

    @Published var presentPopup: Bool = false
    @Published var popup = ZCNToast.ZCNToastType.success("YES")

    override init() {
        super.init()
        VultViewModel.zboxAllocationHandle = try? ZcncoreManager.zboxStorageSDKHandle?.getAllocation(Utils.get(key: .allocationID) as? String)
        self.getAllocation()
    }
    
    func getAllocation()  {
        DispatchQueue.global().async {
                let decoder = JSONDecoder()
                
                guard let zboxAllocationHandle = VultViewModel.zboxAllocationHandle else { return }
                
                var error: NSError?
                let jsonStr = SdkGetAllocations(&error)
                
            if let data = jsonStr.data(using: .utf8), let allocations = try? JSONDecoder().decode([Allocation].self, from: data), let allocation = allocations.first {
                DispatchQueue.main.async {
                    self.allocation = allocation
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
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
        var thumbnailPath: URL? =  Utils.downloadedThumbnailPath.appendingPathComponent(name)
        
        if let image = ZCNImage(data: data) {
            let pngData = image.pngData()
            try pngData?.write(to: localPath,options: .atomic)
            
            let thumbnailData = image.jpegData(compressionQuality: 0.1)
            try thumbnailData?.write(to: thumbnailPath!)
        } else {
            try data.write(to: localPath,options: .atomic)
            thumbnailPath = nil
        }
        
        try VultViewModel.zboxAllocationHandle?.uploadFile(Utils.tempPath(),
                                                           localPath: localPath.path,
                                                           remotePath: "/\(name)",
                                                           thumbnailPath: thumbnailPath?.path,
                                                           encrypt: false,
                                                           webStreaming: false,
                                                           statusCb: self)
    }
    
    func uploadFiles() {
        
    }
    
    func downloadImage(file: File) {
        do {
            try VultViewModel.zboxAllocationHandle?.downloadFile(file.path,
                                                                 localPath: file.localFilePath.path,
                                                                 statusCb: self)
            DispatchQueue.main.async {
                self.popup = .progress("Downloading \(file.name)")
                self.presentPopup = true
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func listDir() async {
        do {
            let files = try await ZCNFileManager.listDir(remotePath: "/")
            DispatchQueue.main.async {
                self.files = files.list
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getAuthTicket(file: File) -> String {
        
        guard let allocation = VultViewModel.zboxAllocationHandle else { return "" }

        var error: NSError?
        let auth = allocation.getAuthToken(file.path, filename: file.name, referenceType: "f", refereeClientID: "", refereeEncryptionPublicKey: "", expiration: 0, availableAfter: "", error: &error)
        
        return auth
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
        DispatchQueue.main.async {
            self.allocation.addSize(size)
            let action = op == 0 ? "Uploaded" : "Downloaded"
            self.popup = .success("\(action) \(filename ?? "")")
            self.presentPopup = true
        }
    }
    
    func error(_ allocationID: String?, filePath: String?, op: Int, err: Error?) {
        print("error \(filePath) \(err?.localizedDescription)")
        DispatchQueue.main.async {
            if let index = self.files.firstIndex(where: {$0.path == filePath}) {
                self.files[index].status = .error
            }
            self.popup = .error(err?.localizedDescription ?? "Error")
            self.presentPopup = true
        }
    }
    
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
    
    func repairCompleted(_ filesRepaired: Int) {
        
    }
    
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
