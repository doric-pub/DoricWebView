#import "DoricWebViewNode.h"

@implementation DoricWebViewNode
- (WKWebView *)build {
    WKWebView *wkWebView = [WKWebView new];
    wkWebView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    if (@available(iOS 14.0, *)) {
        wkWebView.configuration.defaultWebpagePreferences.allowsContentJavaScript = YES;
    } else {
        wkWebView.configuration.preferences.javaScriptEnabled = YES;
    }
    return wkWebView;
}

- (void)blendView:(WKWebView *)view forPropName:(NSString *)name propValue:(id)prop {
    if ([@"url" isEqualToString:name]) {
        NSURL *url = [NSURL URLWithString:prop];
        if ([url.scheme isEqualToString:@"file"]) {
            [view loadFileURL:url allowingReadAccessToURL:url];
        } else {
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [view loadRequest:request];
        }
    } else if ([@"content" isEqualToString:name]) {
        [view loadHTMLString:prop baseURL:nil];
    } else if ([@"allowJavaScript" isEqualToString:name]) {
        if (@available(iOS 14.0, *)) {
            view.configuration.defaultWebpagePreferences.allowsContentJavaScript = ((NSNumber *) prop).boolValue;
        } else {
            view.configuration.preferences.javaScriptEnabled = ((NSNumber *) prop).boolValue;;
        }
    } else {
        [super blendView:view forPropName:name propValue:prop];
    }
}

- (void)evaluateJavaScript:(NSString *)script withPromise:(DoricPromise *)promise {
    [self.view evaluateJavaScript:script completionHandler:^(id o, NSError *error) {
        if (error) {
            [promise reject:error.localizedDescription];
        } else {
            [promise resolve:o];
        }
    }];
}
@end