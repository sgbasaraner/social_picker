import Flutter
import UIKit
import YPImagePicker
import Photos

public class SwiftSocialPickerPlugin: NSObject, FlutterPlugin {
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "social_picker", binaryMessenger: registrar.messenger())
    let instance = SwiftSocialPickerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    var config = YPImagePickerConfiguration()
    config.screens = [.library, .photo, .video]
    
    let maxVideoDurationSeconds = Double(call.arguments as! Int)
    config.video.trimmerMaxDuration = maxVideoDurationSeconds
    config.video.recordingTimeLimit = maxVideoDurationSeconds
    config.video.libraryTimeLimit = maxVideoDurationSeconds
    config.shouldSaveNewPicturesToAlbum = true
    print("max video duration picked: \(maxVideoDurationSeconds)")
    let picker = YPImagePicker(configuration: config)
    picker.didFinishPicking { [unowned picker] items, _ in
        if let photo = items.singlePhoto {
            print("picked single photo")
            if let asset = photo.asset {
                asset.getURL(completionHandler: { (url) in
                    guard let url = url else {
                        print("URL sending failed")
                        return
                    }
                    print("URL sent: \(url.absoluteString)")
                    result(url.absoluteString)
                })
            } else {
                if let data = photo.image.jpegData(compressionQuality: 0.8) {
                   let filename = getDocumentsDirectory().appendingPathComponent("copy.jpg")
                    do {
                        try data.write(to: filename)
                        print("URL sent: \(filename.absoluteString)")
                        result(filename.absoluteString)
                    } catch _ {
                        
                    }
               }
            }
            
            
        }
        if let video = items.singleVideo {
            print("URL sent: \(video.url)")
            result(video.url)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    let controller: FlutterViewController = UIApplication.shared.delegate!.window!!.rootViewController as! FlutterViewController;
    controller.present(picker, animated: true, completion: nil)
    
  }
    
    
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

extension PHAsset {
    var originalFilename: String? {
        return PHAssetResource.assetResources(for: self).first?.originalFilename
    }
    
    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}
