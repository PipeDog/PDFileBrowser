//
//  PDFilePreviewController.m
//  PDFileBrowser
//
//  Created by liang on 2020/1/4.
//  Copyright © 2020 PipeDog. All rights reserved.
//

#import "PDFilePreviewController.h"
#import <WebKit/WebKit.h>
#import "PDFileBrowser.h"

@interface PDFilePreviewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation PDFilePreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViewHierarchy];
}

- (void)createViewHierarchy {
    [self.view addSubview:self.webView];
    [self.webView addSubview:self.activityIndicatorView];
}

#pragma mark - PDFilePreviewControllerDelegate Methods
- (void)loadFileAtPath:(NSString *)filePath {
    if (!filePath.length) { return; }
    
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];

    if (@available(iOS 9, *)) {
        NSURL *accessURL = [fileURL URLByDeletingLastPathComponent];
        [self.webView loadFileURL:fileURL allowingReadAccessToURL:accessURL];
    } else {
        NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
        [self.webView loadRequest:request];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.activityIndicatorView stopAnimating];
    self.activityIndicatorView.hidden = YES;
    
    // Handle error...
    NSLog(@"error: %@", error);
    
    self.navigationItem.prompt = @"Error";
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.activityIndicatorView stopAnimating];
    self.activityIndicatorView.hidden = YES;
}

#pragma mark - Getter Methods
- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.allowsLinkPreview = YES;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.hidden = YES;
        
        CGSize size = CGSizeMake(100.f, 100.f);
        CGRect rect = CGRectMake((CGRectGetWidth(self.view.bounds) - size.width) / 2.f,
                                 (CGRectGetHeight(self.view.bounds) - size.height) / 2.f,
                                 size.width,
                                 size.height);
        _activityIndicatorView.frame = rect;
    }
    return _activityIndicatorView;
}

@end
