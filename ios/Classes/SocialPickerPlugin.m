#import "SocialPickerPlugin.h"
#if __has_include(<social_picker/social_picker-Swift.h>)
#import <social_picker/social_picker-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "social_picker-Swift.h"
#endif

@implementation SocialPickerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSocialPickerPlugin registerWithRegistrar:registrar];
}
@end
