#import "DoricWebViewLibrary.h"
#import "DoricDemoPlugin.h"

@implementation DoricWebViewLibrary
- (void)load:(DoricRegistry *)registry {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *fullPath = [path stringByAppendingPathComponent:@"bundle_doricwebview.js"];
    NSString *jsContent = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
    [registry registerJSBundle:jsContent withName:@"doricwebview"];
    [registry registerNativePlugin:DoricDemoPlugin.class withName:@"demoPlugin"];
}
@end