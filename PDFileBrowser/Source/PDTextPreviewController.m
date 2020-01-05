//
//  PDTextPreviewController.m
//  PDLogger
//
//  Created by liang on 2020/1/4.
//  Copyright © 2020 liang. All rights reserved.
//

#import "PDTextPreviewController.h"

@interface PDTextPreviewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation PDTextPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViewHierarchy];
}

- (void)createViewHierarchy {
    [self.view addSubview:self.textView];
    [self.view addSubview:self.activityIndicatorView];
}

#pragma mark - PDFilePreviewControllerDelegate
- (void)loadFileAtPath:(NSString *)filePath {
    if (!filePath.length) { return; }
    
    self.title = [filePath lastPathComponent];
    [self.activityIndicatorView startAnimating];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        NSData *data = [NSData dataWithContentsOfURL:fileURL];
        NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.text = text;
            [self.activityIndicatorView stopAnimating];
        });
    });
}

#pragma mark - Getter Methods
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
        _textView.backgroundColor = [UIColor blackColor];
        _textView.font = [UIFont systemFontOfSize:12];
        _textView.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f];
        _textView.editable = NO;
        _textView.selectable = YES;
    }
    return _textView;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
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
