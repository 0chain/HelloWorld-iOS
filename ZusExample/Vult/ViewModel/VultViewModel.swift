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
import Photos
import AVKit

class VultViewModel: NSObject, ObservableObject {
    
    @Published var allocation: Allocation = Allocation.default
    
    @Published var presentAllocationDetails: Bool = false
    @Published var presentDocumentPicker: Bool = false

    @Published var files: Files = []
    @Published var selectedPhotos: [PHPickerResult] = [] //[PhotosPickerItem] = []

    @Published var selectedFile: File? = nil
    @Published var openFile: Bool = false

    @Published var presentPopup: Bool = false
    @Published var popup = ZCNToast.ZCNToastType.success("YES")

    lazy var callback: ZboxStatusCallback = {
        let callback = ZboxStatusCallback(completedHandler: self.completed(filePath:filename:mimetype:size:op:), errorHandler: self.error(filePath:op:err:), inProgressHandler: self.inProgress(file:op:), startedHandler: self.started(file:op:))
        return callback
    }()
    
    override init() {
        super.init()
        ZCNFileManager.setAllocationID(id: Utils.get(key: .allocationID) as? String ?? "")
        self.getAllocation()
    }
    
    func getAllocation() {
        Task {
            do {
                let allocation = try await ZCNFileManager.getAllocation()
                DispatchQueue.main.async {
                    self.allocation = allocation
                }
            } catch {
                
            }
        }
    }
    
    //func uploadImage(selectedPhotos: [PhotosPickerItem]) {
    func uploadImage(selectedPhotos: [PHPickerResult]) {
        Task {
            var files: Files = []
            do {
                let identifiers = selectedPhotos.compactMap(\.assetIdentifier)
                let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
                for index in 0..<fetchResult.count {
                  let asset = fetchResult.object(at: index)
                    do {
                    let image = try await asset.requestImage()
                      if let data = image.pngData() {
                          //try uploadFile(data: data, name: name)
                          var file = File()
                          file.name = asset.value(forKey: "filename") as? String ?? Date().timeIntervalSince1970.description
                          file.path = "/\(asset.value(forKey: "filename") as? String ?? Date().timeIntervalSince1970.description)"
                          try file.saveFile(data: data)
                          try await file.generateThumbnail()
                          files.append(file)
                      }
                    } catch let error {
                      print(error)
                    }
                  }
                  
                try self.uploadFiles(files: files)
                /*for newItem in selectedPhotos {
                    let name = Date().timeIntervalSince1970.description //PHAsset.fetchAssets(withLocalIdentifiers: [newItem.itemIdentifier!], options: nil).firstObject?.value(forKey: "filename") as? String ?? ""
                   // if let data = try await newItem.loadTransferable(type: Data.self) {
                    if let data = newItem.pngData() {
                        //try uploadFile(data: data, name: name)
                        var file = File()
                        file.name = name
                        file.path = "/\(name)"
                        try file.saveFile(data: data)
                        try await file.generateThumbnail()
                        files.append(file)
                    }
                }
                try self.uploadFiles(files: files)*/
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func uploadDocument(result: Result<URL, Error>) {
        Task {
            var files = [File]()
            do {
                let url = try result.get()
                guard url.startAccessingSecurityScopedResource() else { return }
                let name = url.lastPathComponent
                let data = try Data(contentsOf: url)
                var file = File()
                file.name = name
                file.path = "/\(name)"
                try file.saveFile(data: data)
                try await file.generateThumbnail()
                files.append(file)
                try self.uploadFiles(files: files)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func uploadFiles(files: [File]) throws {
        let options = files.map { MultiUpload(fileName: $0.name, filePath: $0.localUploadPath.path, thumbnailPath: $0.localThumbnailPath.path, remotePath: "/", encrypt: false) }
        try ZCNFileManager.multiUploadFiles(workdir: Utils.tempPath(),
                                        options: options,
                                        statusCb: callback)
    }
    
    func downloadImage(file: File) {
        do {
            try ZCNFileManager.downloadFile(remotePath: file.path, localPath: file.localFilePath.path, statusCb: self.callback)
            
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
    
    func copyAuthToken(file: File) {
        do {
            let token = try ZCNFileManager.getAuthTicket(file: file)
            UIPasteboard.general.string = token
        } catch {
            
        }
    }
    
}

extension VultViewModel {

    func completed( filePath: String?, filename: String?, mimetype: String?, size: Int, op: FileOperation) {
        DispatchQueue.main.async {
            if let index = self.files.firstIndex(where: {$0.path == filePath}) {
                self.files[index].completedBytes = size
                self.files[index].status = .completed
                if op == .upload {
                    self.files[index].isUploaded = true
                    self.files[index]._isDownloaded = true
                }
            }
            self.allocation.addSize(size)
            let action = op == .upload ? "Uploaded" : "Downloaded"
            self.popup = .success("\(action) \(filename ?? "")")
            self.presentPopup = true
        }
    }
    
    func error(filePath: String?, op: FileOperation, err: Error?) {
        DispatchQueue.main.async {
            if let index = self.files.firstIndex(where: {$0.path == filePath}) {
                self.files[index].status = .error
            }
            self.popup = .error(err?.localizedDescription ?? "Error")
            self.presentPopup = true
        }
    }
    
    func inProgress(file: File, op: FileOperation) {
        DispatchQueue.main.async {
            if op == .upload {
                if let index = self.files.firstIndex(where: {$0.path == file.path}) {
                    self.files[index].completedBytes = file.completedBytes
                } else {
                    self.files.append(file)
                }
            }
        }
    }
    
    func started(file: File, op: FileOperation) {
        if op == .upload {
            DispatchQueue.main.async {
                self.files.insert(file, at: 0)
            }
        }
    }
    
}
