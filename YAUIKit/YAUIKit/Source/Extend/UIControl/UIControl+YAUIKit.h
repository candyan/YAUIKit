//
//  UIControl+YAUIKit.h
//  YAUIKit
//
//  Created by liu yan on 9/17/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YAActionBlock)(UIEvent *event);

@interface UIControl (YAUIKit)

- (void)addActionBlock:(YAActionBlock)block forControlEvents:(UIControlEvents)controlEvents;
- (void)removeActionBlockForControlEvents:(UIControlEvents)controlEvents;

@end
