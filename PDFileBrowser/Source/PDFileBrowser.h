//
//  PDFileBrowser.h
//  PDSandbox
//
//  Created by liang on 2018/3/29.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PDFilePreviewControllerDelegate <NSObject>

- (void)loadFileURL:(NSURL *)fileURL;

@end

@interface PDFileBrowser : NSObject

@property (class, strong, readonly) PDFileBrowser *defaultBrowser;

// @param filterHiddenFiles If YES, hidden files are not displayed.
- (void)presentFileBrowser:(BOOL)filterHiddenFiles;

- (void)setFilePreviewController:(UIViewController<PDFilePreviewControllerDelegate> * (^)(void))block;

@end
