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
    UIWindow *keyboardWindow = nil;

    for (UIWindow *window in windows) {
        if ([window isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")]) {
            keyboardWindow = window;
            break;
        }
    }

    if (keyboardWindow == nil) {
        keyboardWindow = windows.firstObject;
    }

    return keyboardWindow;
}

@end
