//
//  ZboxStatusCallbackMocked.swift
//  Vult
//
//  Created by Aaryan Kothari on 27/02/23.
//  Copyright © 2023 0Chain. All rights reserved.
//

import Foundation
import Zcncore

public class ZboxStatusCallback: NSObject, ZboxStatusCallbackMockedProtocol {
  
    public typealias CommitMetaCompletionHandler = (String?, String?, Error?) -> Void
    public typealias CompletedHandler = (String?, String?, String?, Int, FileOperation) -> Void
    public typealias ErrorHandler = (String?, FileOperation, Error?) -> Void
    public typealias InProgressHandler = (File, FileOperation) -> Void
    public typealias RepairCompletedHandler = (Int) -> Void
    public typealias StartedHandler = (File, FileOperation) -> Void
  
  var commitMetaCompletionHandler: CommitMetaCompletionHandler?
  var completedHandler: CompletedHandler?
  var errorHandler: ErrorHandler?
  var inProgressHandler: InProgressHandler?
  var repairCompletedHandler: RepairCompletedHandler?
  var startedHandler: StartedHandler?
  
    public init(commitMetaCompletionHandler: CommitMetaCompletionHandler? = nil,
       completedHandler: CompletedHandler? = nil,
       errorHandler: ErrorHandler? = nil,
       inProgressHandler: InProgressHandler? = nil,
       repairCompletedHandler: RepairCompletedHandler? = nil,
       startedHandler: StartedHandler? = nil) {
    self.commitMetaCompletionHandler = commitMetaCompletionHandler
    self.completedHandler = completedHandler
    self.errorHandler = errorHandler
    self.inProgressHandler = inProgressHandler
    self.repairCompletedHandler = repairCompletedHandler
    self.startedHandler = startedHandler
  }
  
  public func commitMetaCompleted(_ request: String?, response: String?, err: Error?) {
    DispatchQueue.main.async { [weak self] in
      self?.commitMetaCompletionHandler?(request, response, err)
    }
  }
  
  public func completed(_ allocationId: String?, filePath: String?, filename: String?, mimetype: String?, size: Int, op: Int) {
    DispatchQueue.main.async { [weak self] in
      self?.completedHandler?(filePath, filename, mimetype, size, FileOperation(rawValue: op)!)
      print("\(Date().debugDescription) 🚜 completed \(String(describing: FileOperation(rawValue: op)!)) at \(filePath ?? "") \(size) bytes")
    }
  }
  
  public func error(_ allocationID: String?, filePath: String?, op: Int, err: Error?) {
    DispatchQueue.main.async { [weak self] in
      self?.errorHandler?(filePath, FileOperation(rawValue: op)!, err)
      print("\(Date().debugDescription) 🚜 error \(String(describing: FileOperation(rawValue: op)!)) at \(filePath ?? "")")
    }
  }
  
  public func inProgress(_ allocationId: String?, filePath: String?, op: Int, completedBytes: Int, data: Data?) {
    DispatchQueue.main.async { [weak self] in
        var file = File()
        file.path = filePath ?? ""
        file.name = filePath?.replacingOccurrences(of: "/", with: "") ?? ""
        file.completedBytes = completedBytes
        file.status = .progress
      self?.inProgressHandler?(file, FileOperation(rawValue: op)!)
      print("\(Date().debugDescription) 🚜 progress \(String(describing: FileOperation(rawValue: op)!)) at \(filePath ?? "") \(completedBytes) bytes")
    }
  }
  
  public func repairCompleted(_ filesRepaired: Int) {
    DispatchQueue.main.async { [weak self] in
      self?.repairCompletedHandler?(filesRepaired)
    }
  }
  
  public func started(_ allocationId: String?, filePath: String?, op: Int, totalBytes: Int) {
    DispatchQueue.main.async { [weak self] in
            var file = File()
            file.path = filePath ?? ""
            file.name = filePath?.replacingOccurrences(of: "/", with: "") ?? ""
            file.size = totalBytes
            file.completedBytes = 0
            file.status = .progress
      self?.startedHandler?(file, FileOperation(rawValue: op)!)
      print("\(Date().debugDescription) 🚜 started \(String(describing: FileOperation(rawValue: op)!)) at \(filePath ?? "")")
    }
  }
  
    public  func updateHandlers(commitMetaCompletionHandler: CommitMetaCompletionHandler?,
                      completedHandler: CompletedHandler?,
                      errorHandler: ErrorHandler?,
                      inProgressHandler: InProgressHandler?,
                      repairCompletedHandler: RepairCompletedHandler?,
                      startedHandler: StartedHandler?) {
    
    if let newHandler = commitMetaCompletionHandler {
      self.commitMetaCompletionHandler = newHandler
    }
    
    if let newHandler = completedHandler {
      self.completedHandler = newHandler
    }
    
    if let newHandler = errorHandler {
      self.errorHandler = newHandler
    }
    
    if let newHandler = inProgressHandler {
      self.inProgressHandler = newHandler
    }
    
    if let newHandler = repairCompletedHandler {
      self.repairCompletedHandler = newHandler
    }
    
    if let newHandler = startedHandler {
      self.startedHandler = newHandler
    }
  }
}
