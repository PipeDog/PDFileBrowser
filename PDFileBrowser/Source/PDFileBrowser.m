//
//  PDFileBrowser.m
//  PDSandbox
//
//  Created by liang on 2018/3/29.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import "PDFileBrowser.h"
#import "PDFileBrowser+Internal.h"
#import "PDFileBrowseController.h"
#import "PDFilePreviewController.h"

@implementation PDFileBrowser

+ (PDFileBrowser *)defaultBrowser {
    static PDFileBrowser *__defaultBrowser;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __defaultBrowser = [[PDFileBrowser alloc] init];
    });
    return __defaultBrowser;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _filePreviewControllerBlock = ^ {
            return [[PDFilePreviewController alloc] init];
        };
    }
    return self;
}

- (void)presentFileBrowser:(BOOL)filterHiddenFiles {
    PDFileBrowseController *browseController = [[PDFileBrowseController alloc] init];
    browseController.filterHiddenFiles = filterHiddenFiles;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:browseController];
    
    UIViewController *rootVC = [self effectiveWindow].rootViewController;
    [rootVC presentViewController:navigationController animated:YES completion:nil];
}

- (void)setFilePreviewController:(UIViewController<PDFilePreviewControllerDelegate> *(^)(void))block {
    if (block) {
        _filePreviewControllerBlock = block;
    }
}

#pragma mark - Private Methods
- (UIWindow *)effectiveWindow {
    UIWindow *window = nil;
    
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                window = windowScene.windows.firstObject;
                break;
            }
        }
    } else {
        window = [UIApplication sharedApplication].keyWindow;
    }
    return window;
}

@end
