//
//  UIImage+YAUIKit.h
//  YAUIKit
//
//  Created by Tony Li on 10/14/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YAUIKit)

/**
 * 读取名为 name 的图片。
 *
 * 与 +[UIImage imageNamed:] 不同的是
 *  - 本方法不会缓存图片，更适用于读取不需要频繁访问的图片；
 *  - 自动查找为iPhone 5指定的图片。
 *
 * iPhone 5图片的命名规则为： imageName-568h@2x.png
 */
+ (UIImage *)imageWithName:(NSString *)name;

@end
