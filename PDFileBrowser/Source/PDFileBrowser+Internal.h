//
//  PDFileBrowser+Internal.h
//  PDFileBrowser
//
//  Created by liang on 2020/1/4.
//  Copyright © 2020 PipeDog. All rights reserved.
//

#import "PDFileBrowser.h"

NS_ASSUME_NONNULL_BEGIN

@interface PDFileBrowser ()

@property (nonatomic, copy) UIViewController<PDFilePreviewControllerDelegate> * (^filePreviewControllerBlock)(void);

@end

NS_ASSUME_NONNULL_END
