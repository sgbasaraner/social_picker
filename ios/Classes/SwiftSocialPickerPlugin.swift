import Flutter
import UIKit
import YPImagePicker

public class SwiftSocialPickerPlugin: NSObject, FlutterPlugin {
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "social_picker", binaryMessenger: registrar.messenger())
    let instance = SwiftSocialPickerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let picker = YPImagePicker()
    picker.didFinishPicking { [unowned picker] items, _ in
        if let photo = items.singlePhoto {
            print(photo.fromCamera) // Image source (camera or library)
            print(photo.image) // Final image selected by the user
            print(photo.originalImage) // original image selected by the user, unfiltered
            print(photo.modifiedImage) // Transformed image, can be nil
            print(photo.exifMeta) // Print exif meta data of original image.
        }
        picker.dismiss(animated: true, completion: nil)
    }
    let controller: FlutterViewController = UIApplication.shared.delegate!.window!!.rootViewController as! FlutterViewController;
    controller.present(picker, animated: true, completion: nil)
    
  }
}
