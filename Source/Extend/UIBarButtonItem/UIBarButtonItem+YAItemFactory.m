//
//  UIBarButtonItem+YAItemFactory.m
//  YAUIKit
//
//  Created by Candyan on 14-3-4.
//  Copyright (c) 2014 Candyan. All rights reserved.
//

#import "UIBarButtonItem+YAItemFactory.h"
#import "UIColor+YAHexColor.h"
#import "UIControl+YAUIKit.h"
#import "UIFont+YAUIKit.h"

@implementation UIBarButtonItem (YAItemFactory)

static CGFloat const kPABarButtonItemsDefaultSpace = -14.0f;
static CGFloat const kPABarButtonDefaultSize = 44.0f;

#pragma mark - Creator With Image

+ (NSArray *)barButtonItemsWithImage:(UIImage *)image actionBlock:(void (^)())actionBlock
{
    return [self barButtonItemsWithImage:image space:0 actionBlock:actionBlock];
}

+ (NSArray *)barButtonItemsWithImage:(UIImage *)image space:(CGFloat)space actionBlock:(void (^)())actionBlock
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, kPABarButtonDefaultSize, kPABarButtonDefaultSize)];
    [button addActionBlock:^(UIEvent *event) {
      if (actionBlock)
          actionBlock();
    }
          forControlEvents:UIControlEventTouchUpInside];

    return [self barButtonItemsWithCustomView:button space:space];
}

#pragma mark - Creator with String

+ (NSArray *)barButtonItemsWithTitle:(NSString *)title actionBlock:(void (^)())actionBlock
{
    return [self barButtonItemsWithTitle:title space:0 actionBlock:actionBlock];
}

+ (NSArray *)barButtonItemsWithTitle:(NSString *)title space:(CGFloat)space actionBlock:(void (^)())actionBlock
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont helveticaFontOfSize:17.0f]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHex:0x005750] forState:UIControlStateDisabled];

    CGSize titleSize = [title sizeWithFont:button.titleLabel.font];
    [button setFrame:CGRectMake(0, 0, kPABarButtonDefaultSize, ceilf(titleSize.width))];

    [button addActionBlock:^(UIEvent *event) {
      if (actionBlock)
          actionBlock();
    }
          forControlEvents:UIControlEventTouchUpInside];
    return [self barButtonItemsWithCustomView:button space:space];
}

#pragma mark - Creator with custom view

+ (NSArray *)barButtonItemsWithCustomView:(UIView *)customView
{
    return [self barButtonItemsWithCustomView:customView space:0];
}

+ (NSArray *)barButtonItemsWithCustomView:(UIView *)customView space:(CGFloat)space
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    if (space == 0) {
        return @[ barButtonItem ];
    }

    UIBarButtonItem *spaceItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    CGFloat finalSpace = space;
    CGFloat maxScreenLength = MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && maxScreenLength == 736.0) {
        finalSpace -= 20;
    }
    else {
        finalSpace -= 16;
    }
    [spaceItem setWidth:finalSpace];
    return @[ spaceItem, barButtonItem ];
}

@end
