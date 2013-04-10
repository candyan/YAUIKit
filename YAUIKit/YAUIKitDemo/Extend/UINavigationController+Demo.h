//
//  UINavigationController+Demo.h
//  YAUIKit
//
//  Created by liu yan on 4/9/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Demo)

- (void) pushViewControllerWithDemoAnimation:(UIViewController *)viewController;

- (UIViewController *) popViewControllerWithDemoAnimation;

@end
