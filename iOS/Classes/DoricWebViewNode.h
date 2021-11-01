#import <Foundation/Foundation.h>
#import <DoricCore/Doric.h>
#import <WebKit/WebKit.h>

@interface DoricWebView : WKWebView

@property (nonatomic, assign) CGFloat contentFitHeight;

@end

@interface DoricWebViewNode : DoricViewNode<DoricWebView *> <WKNavigationDelegate>

@end
