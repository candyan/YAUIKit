//
//  UIWindow+YAHierarchy.m
//  YAUIKit
//
//  Created by liuyan on 12/18/15.
//  Copyright © 2015 liu yan. All rights reserved.
//

#import "UIWindow+YAHierarchy.h"

@implementation UIWindow (YAHierarchy)

- (UIViewController *)visibleViewController
{
    UIViewController *rootViewController = self.rootViewController;
    return [UIWindow ar_getVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *)ar_getVisibleViewControllerFrom:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [UIWindow ar_getVisibleViewControllerFrom:[((UINavigationController *)vc)visibleViewController]];
    }
    else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [UIWindow ar_getVisibleViewControllerFrom:[((UITabBarController *)vc)selectedViewController]];
    }
    else {
        if (vc.presentedViewController) {
            return [UIWindow ar_getVisibleViewControllerFrom:vc.presentedViewController];
        }
        else {
            return vc;
        }
    }
}

@end
