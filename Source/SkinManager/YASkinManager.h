//
//  YASkinManager.h
//  PupaDemo
//
//  Created by liuyan on 14-3-12.
//  Copyright (c) 2014年 Douban.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef YASkinColor
#define YASkinColor(__KEY) [[YASkinManager sharedManager] colorForTag:__KEY]
#endif

#ifndef YASkinFont
#define YASkinFont(__KEY) [[YASkinManager sharedManager] fontForTag:__KEY]
#endif

#ifndef YASkinImage
#define YASkinImage(__KEY) [[YASkinManager sharedManager] imageWithName:__KEY]
#endif

@interface YASkinManager : NSObject
{
  NSCache *_imageCache;
}

@property (nonatomic, copy) NSString *skinName;

+ (instancetype)sharedManager;

- (instancetype)initWithSkinName:(NSString *)skinName;

- (UIColor *)colorForTag:(NSString *)tag;
- (UIFont *)fontForTag:(NSString *)tag;

// PNG Image Only.

- (UIImage *)imageWithName:(NSString *)imageName;
- (UIImage *)imageWithName:(NSString *)imageName cache:(BOOL)flag;
- (void)cleanImageCache;

@end
