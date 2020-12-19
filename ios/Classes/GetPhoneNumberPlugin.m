#import "GetPhoneNumberPlugin.h"
#if __has_include(<get_phone_number/get_phone_number-Swift.h>)
#import <get_phone_number/get_phone_number-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "get_phone_number-Swift.h"
#endif

@implementation GetPhoneNumberPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGetPhoneNumberPlugin registerWithRegistrar:registrar];
}
@end
