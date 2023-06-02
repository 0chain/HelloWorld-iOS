
import ZCNSwift

extension File {
    var localThumbnailPath: URL {
        return Utils.downloadedThumbnailPath.appendingPathComponent(self.path)
    }
    
    var localUploadPath: URL {
        return Utils.uploadPath.appendingPathComponent(self.path)
    }
    
    var localFilePath: URL {
        return Utils.downloadPath.appendingPathComponent(self.path)
    }
    
    var isDownloaded: Bool {
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
    
    
}
