#import "DoricWebViewLibrary.h"
#import "DoricWebViewNode.h"

@implementation DoricWebViewLibrary
- (void)load:(DoricRegistry *)registry {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *fullPath = [path stringByAppendingPathComponent:@"bundle_doricwebview.js"];
    NSString *jsContent = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
    [registry registerJSBundle:jsContent withName:@"doric-webview"];
    [registry registerViewNode:DoricWebViewNode.class withName:@"WebView"];
}
@end