//
//  PDFileBrowser.h
//  PDSandbox
//
//  Created by liang on 2018/3/29.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDFileBrowser : NSObject

@property (class, strong, readonly) PDFileBrowser *defaultBrowser;

- (void)present;

@end
