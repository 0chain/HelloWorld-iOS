
import ZCNSwift
import QuickLookThumbnailing
import UIKit

extension File {
    var localThumbnailPath: URL {
        return Utils.downloadedThumbnailPath.appendingPathComponent(self.path.replacingOccurrences(of: "/", with: "_"))
    }
    
    var localUploadPath: URL {
        return Utils.uploadPath.appendingPathComponent(self.path.replacingOccurrences(of: "/", with: "_"))
    }
    
    var localFilePath: URL {
        return Utils.downloadPath.appendingPathComponent(self.path.replacingOccurrences(of: "/", with: "_"))
    }
    
    var isDownloaded: Bool {
        return _isDownloaded || isAvailableOffline
    }
    
    var isAvailableOffline: Bool {
        return FileManager.default.fileExists(atPath: localFilePath.path)
    }
    
    var fileSize: String {
        switch status {
        case .completed: return size.formattedByteCount
        case .progress:
            let progress = Double(completedBytes) / Double(size) * 100
            let roundedProgress = String(format: "%.2f %%", progress)
            return roundedProgress
        case .error: return "failed"
        }
    }
    
    var fileDownloadPercent: String {
        return "\(completedBytes/size) %"
    }
    
    func saveFile(data: Data?) throws {
        try data?.write(to: localUploadPath, options: .atomic)
    }
    
    func generateThumbnail() async throws {
        let thumbnailSize = CGSize(width: 100, height: 100)
        let request = await QLThumbnailGenerator.Request(fileAt: localUploadPath, size: thumbnailSize, scale: UIScreen.main.scale, representationTypes: .thumbnail)
        let generator = QLThumbnailGenerator.shared
        let thumbnail = try await generator.generateBestRepresentation(for: request)
        try thumbnail.uiImage.pngData()?.write(to: localThumbnailPath)
    }
    
}
