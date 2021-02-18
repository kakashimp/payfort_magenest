#import "PayfortMagenestPlugin.h"
#if __has_include(<payfort_magenest/payfort_magenest-Swift.h>)
#import <payfort_magenest/payfort_magenest-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "payfort_magenest-Swift.h"
#endif

@implementation PayfortMagenestPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPayfortMagenestPlugin registerWithRegistrar:registrar];
}
@end
