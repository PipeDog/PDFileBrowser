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

@interface PDFilePreviewController ()

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation PDFilePreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViewHierarchy];
}

- (void)createViewHierarchy {
    [self.view addSubview:self.webView];
}

#pragma mark - PDFilePreviewControllerDelegate Methods
- (void)loadFileURL:(NSURL *)URL {
    if (!URL.absoluteString.length) { return; }
    
    if ([URL.absoluteString hasPrefix:@"file://"]) {
        NSURL *accessURL = [URL URLByDeletingLastPathComponent];
        [self.webView loadFileURL:URL allowingReadAccessToURL:accessURL];
    } else {
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        [self.webView loadRequest:request];
    }
    
    self.title = URL.absoluteString;
}

#pragma mark - Getter Methods
- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        [configuration.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

@end
