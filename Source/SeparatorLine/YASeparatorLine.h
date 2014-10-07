//
//  YASeparatorLine.h
//  YAUIKit
//
//  Created by Candyan on 14-3-23.
//  Copyright (c) 2014 Candyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YASeparatorLine : UIView

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;

- (id)initWithFrame:(CGRect)frame
          lineColor:(UIColor *)lineColor
          lineWidth:(CGFloat)lineWidth;

@end
