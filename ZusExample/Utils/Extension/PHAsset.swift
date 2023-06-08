//
//  PHAsset.swift
//  ZusExample
//
//  Created by Vijay Kachhadiya on 08/06/23.
//

import Foundation
import Photos.PHAsset
import UIKit.UIImage
import Photos
import UIKit

extension PHAsset {
  
  func requestImage(
    targetSize: CGSize? = nil,
    contentMode: PHImageContentMode = .aspectFit,
    options: PHImageRequestOptions? = nil
  ) async throws -> UIImage {
    options?.isSynchronous = false
    
    var requestID: PHImageRequestID?
    let manager = PHImageManager.default()
    
    return try await withTaskCancellationHandler(
      handler: { [requestID] in
        guard let requestID = requestID else {
          return
        }
        
        manager.cancelImageRequest(requestID)
      }
    ) {
      try await withCheckedThrowingContinuation { continuation in
        requestID = manager.requestImage(
          for: self,
          targetSize: targetSize ?? CGSize(width: pixelWidth, height: pixelHeight),
          contentMode: contentMode,
          options: options
        ) { image, info in
          if let error = info?[PHImageErrorKey] as? Error {
            continuation.resume(throwing: error)
            return
          }
          
          guard !(info?[PHImageCancelledKey] as? Bool ?? false) else {
            continuation.resume(throwing: CancellationError())
            return
          }
          
          // When degraded image is provided, the completion handler will be called again.
          guard !(info?[PHImageResultIsDegradedKey] as? Bool ?? false) else {
            return
          }
          
          guard let image = image else {
            // This should in theory not happen.
            continuation.resume(throwing: NSError(domain: "Image not found", code: -1))
            return
          }
          
          // According to the docs, the image is guaranteed at this point.
          continuation.resume(returning: image)
        }
      }
    }
  }
  
  func requestVideo(
    targetSize: CGSize? = nil,
    contentMode: PHImageContentMode = .aspectFit,
    options: PHVideoRequestOptions? = nil
  ) async throws -> AVURLAsset {
    
    var requestID: PHImageRequestID?
    let manager = PHImageManager.default()
    
    return try await withTaskCancellationHandler(
      handler: { [requestID] in
        guard let requestID = requestID else {
          return
        }
        
        manager.accessibilityPath?.lineCapStyle
      }
    ) {
      try await withCheckedThrowingContinuation { continuation in
        requestID = manager.requestAVAsset(forVideo: self, options: options) {  asset, _, info in
          
          if let error = info?[PHImageErrorKey] as? Error {
            continuation.resume(throwing: error)
            return
          }
          
          guard !(info?[PHImageCancelledKey] as? Bool ?? false) else {
            continuation.resume(throwing: CancellationError())
            return
          }
          
          // When degraded image is provided, the completion handler will be called again.
          guard !(info?[PHImageResultIsDegradedKey] as? Bool ?? false) else {
            return
          }
          
          guard let asset = asset as? AVURLAsset else {
            continuation.resume(throwing: NSError(domain: "Asset not found", code: -1))
            return
          }
          
          continuation.resume(returning: asset)
        }
      }
    }
  }
  
  class var options: PHFetchOptions {
    let options = PHFetchOptions()
    options.sortDescriptors = [NSSortDescriptor(
      key: "creationDate",
      ascending: false
    )]
    
    options.predicate = NSPredicate(
      format: "mediaType = %d OR mediaType = %d",
      PHAssetMediaType.video.rawValue,
      PHAssetMediaType.image.rawValue
    )
    return options
  }
  
  class var recentOptions: PHFetchOptions {
    let options = PHFetchOptions()
    options.sortDescriptors = [NSSortDescriptor(
      key: "creationDate",
      ascending: false
    )]
    
    let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()) ?? Date()
    
    options.predicate = NSPredicate(
      format: "( mediaType = %d OR mediaType = %d ) AND ( creationDate > %@ )",
      PHAssetMediaType.video.rawValue,
      PHAssetMediaType.image.rawValue,
      oneWeekAgo as NSDate
    )
    
    return options
  }
  
}


