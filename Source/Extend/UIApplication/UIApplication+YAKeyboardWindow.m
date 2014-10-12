//
//  UIApplication+YAKeyboardWindow.m
//  YAUIKit
//
//  Created by liuyan on 14-10-12.
//  Copyright (c) 2014年 liu yan. All rights reserved.
//

#import "UIApplication+YAKeyboardWindow.h"

@implementation UIApplication (YAKeyboardWindow)

- (UIWindow *)keyboardWindow
{
  NSArray *windows = self.windows;
  return (windows.count > 1) ? windows[1] : windows.firstObject;
}

@end
