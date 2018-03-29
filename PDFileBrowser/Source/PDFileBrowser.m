//
//  PDFileBrowser.m
//  PDSandbox
//
//  Created by liang on 2018/3/29.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import "PDFileBrowser.h"
#import "PDFileBrowseController.h"

@implementation PDFileBrowser

+ (PDFileBrowser *)defaultBrowser {
    static PDFileBrowser *__defaultBrowser;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __defaultBrowser = [[PDFileBrowser alloc] init];
    });
    return __defaultBrowser;
}

- (void)present {
#ifdef DEBUG
    PDFileBrowseController *browseController = [[PDFileBrowseController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:browseController];
    
    UIViewController *rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [rootVC presentViewController:navigationController animated:YES completion:nil];
#endif
}

@end
