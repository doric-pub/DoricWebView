#import "DoricWebViewNode.h"
#import <objc/runtime.h>

@implementation DoricWebView

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize tempSize = [super sizeThatFits:size];
    if (self.contentFitHeight > 0) {
        tempSize.height = self.contentFitHeight;
    }
    return tempSize;
}

@end


@interface DoricWebViewNode(KVO)

@property (nonatomic, assign) BOOL isObserver;

@end

@implementation DoricWebViewNode (KVO)

- (BOOL)isObserver {
    return [(NSNumber *)objc_getAssociatedObject(self, @selector(isObserver)) boolValue];
}

- (void)setIsObserver:(BOOL)isObserver {
    objc_setAssociatedObject(self, @selector(isObserver), @(isObserver), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@implementation DoricWebViewNode
- (DoricWebView *)build {
    DoricWebView *wkWebView = [DoricWebView new];
    wkWebView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    wkWebView.navigationDelegate = self;
    if (@available(iOS 14.0, *)) {
        wkWebView.configuration.defaultWebpagePreferences.allowsContentJavaScript = YES;
    } else {
        wkWebView.configuration.preferences.javaScriptEnabled = YES;
    }
    return wkWebView;
}

- (void)blendView:(DoricWebView *)view forPropName:(NSString *)name propValue:(id)prop {
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

- (void)updateWebViewRealHeight:(CGFloat)realHeight webView:(DoricWebView *)webView {
    // ??????????????????????????????layout
    if (realHeight == webView.contentFitHeight) {
        return;
    }
    webView.contentFitHeight = realHeight;
    DoricSuperNode *node = self.superNode;
    while (node.superNode != nil) {
        node = node.superNode;
    }
    [node requestLayout];
}

- (void)checkWebViewReadyState {
    if ([self.view isKindOfClass:[DoricWebView class]]) {
        DoricWebView *webView = (DoricWebView *)self.view;
        [webView evaluateJavaScript:@"document.readyState" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            if (result && [result isKindOfClass:[NSString class]]) {
                BOOL complete = [(NSString *)result isEqualToString:@"complete"];
                if (complete) {
                    if ([self isObserver]) {
                        self.isObserver = NO;
                        [webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
                        [self updateWebViewRealHeight:webView.scrollView.contentSize.height webView:webView];
                    }
                }
            }
        }];
    }
}

#pragma mark -- WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    __weak typeof(self) weakself = self;
    [webView evaluateJavaScript:@"document.readyState" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (result && [result isKindOfClass:[NSString class]]) {
            BOOL complete = [(NSString *)result isEqualToString:@"complete"];
            // ??????????????????????????????
            if (complete) {
                [webView evaluateJavaScript:@"document.body.scrollWidth" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                    if (result && [result respondsToSelector:@selector(floatValue)]) {
                        CGFloat width = [result floatValue];
                        // ??????????????????????????????????????????js?????????webview???????????????
                        [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                            if (result && [result respondsToSelector:@selector(floatValue)]) {
                                // webView??????????????????????????????????????????????????????????????????????????????????????????
                                CGFloat height = [result floatValue];
                                CGFloat scale = CGRectGetWidth(webView.frame) / width;
                                // ?????????????????????webview????????????
                                CGFloat realHeight = height * scale;
                                [weakself updateWebViewRealHeight:realHeight webView:(DoricWebView *)webView];
                            }
                        }];
                    }
                }];
            } else {
                // ??????????????????????????????KVO??????size??????
                if (![self isObserver]) {
                    self.isObserver = YES;
                    [webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
                }
            }
        }
    }];
}

#pragma mark -- contentSize????????????

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkWebViewReadyState) object:nil];
        [self performSelector:@selector(checkWebViewReadyState) withObject:nil afterDelay:.5];
    }
}

- (void)dealloc {
    @try {
        if (self.view && [self.view isKindOfClass:[DoricWebView class]] && [self isObserver]) {
            DoricWebView *webView = (DoricWebView *)self.view;
            [webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
        }
    } @catch (NSException *exception) {
        NSLog(@"DoricWebView.scrollView????????????KVO?????????");
    }
}

@end

