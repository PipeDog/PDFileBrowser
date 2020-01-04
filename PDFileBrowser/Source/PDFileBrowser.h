//
//  PDFileBrowser.h
//  PDSandbox
//
//  Created by liang on 2018/3/29.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PDFilePreviewControllerDelegate <NSObject>

- (void)loadFileURL:(NSURL *)URL;

@end

@interface PDFileBrowser : NSObject

@property (class, strong, readonly) PDFileBrowser *defaultBrowser;

// @param filterHiddenFiles If YES, hidden files are not displayed.
- (void)presentFileBrowser:(BOOL)filterHiddenFiles;

- (void)setFilePreviewControllerClass:(Class)aClass;
- (Class)filePreviewViewControllerClass;

@end
