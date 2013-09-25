//
//  UIScrollView+YARefreshControl.h
//  YAUIKit
//
//  Created by liuyan on 13-9-24.
//  Copyright (c) 2013年 Douban Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YARefreshControl.h"

@interface UIScrollView (YARefreshControl)

- (void)addRefreshControlWithActionHandler:(void(^)())actionHandler;
- (YARefreshControl *)refreshControl;

@end
