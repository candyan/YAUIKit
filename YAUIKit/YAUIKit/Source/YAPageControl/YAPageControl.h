//
//  YAPageControl.h
//  YAUIKit
//
//  Created by liuyan on 13-11-5.
//  Copyright (c) 2013年 Douban Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YAPageControlStyle){
  kYAPageControlStyleDefault = 0,
  kYAPageControlStyleStrokedCircle = 1,
  kYAPageControlStylePressed1 = 2,
  kYAPageControlStylePressed2 = 3,
  kYAPageControlStyleWithPageNumber = 4,
  kYAPageControlStyleThumb = 5,
  kYAPageControlStyleStrokedSquare = 6,
};

@interface YAPageControl : UIControl

@property (nonatomic, strong) UIColor *coreNormalColor;
@property (nonatomic, strong) UIColor *coreSelectedColor;
@property (nonatomic, strong) UIColor *strokeNormalColor;
@property (nonatomic, strong) UIColor *strokeSelectedColor;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger numberOfPages;

@property (nonatomic, assign) BOOL hidesForSinglePage;
@property (nonatomic, assign) YAPageControlStyle pageControlStyle;

@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, assign) CGFloat diameter;
@property (nonatomic, assign) CGFloat gapWidth;

@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, strong) UIImage *selectedThumbImage;

@property (nonatomic, strong) NSMutableDictionary *thumbImageForIndex;
@property (nonatomic, strong) NSMutableDictionary *selectedThumbImageForIndex;

- (void)setThumbImage:(UIImage *)aThumbImage forIndex:(NSInteger)index;
- (void)setSelectedThumbImage:(UIImage *)aSelectedThumbImage forIndex:(NSInteger)index;

- (UIImage *)thumbImageForIndex:(NSInteger)index;
- (UIImage *)selectedThumbImageForIndex:(NSInteger)index;

@end
