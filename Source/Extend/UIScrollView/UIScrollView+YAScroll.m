//
//  UIScrollView+YAScroll.m
//  Arrietty
//
//  Created by liuyan on 11/20/15.
//  Copyright © 2015 JoyShare Inc. All rights reserved.
//

#import "UIScrollView+YAScroll.h"

@implementation UIScrollView (YAScroll)

- (void)scrollToTop:(BOOL)animated
{
    [self setContentOffset:CGPointMake(0, -self.contentInset.top) animated:animated];
}

- (void)scrollToBottom:(BOOL)animated
{
    [self scrollRectToVisible:CGRectMake(0, (self.contentSize.height + self.contentInset.bottom), 1, 1)
                     animated:animated];
}

@end
