//
//  NSString+YAStringDrawing.h
//  YAUIKit
//
//  Created by liuyan on 13-10-15.
//  Copyright (c) 2013年 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YAStringDrawing)

- (CGSize)sizeWithAttributes:(NSDictionary *)attrs constrainedToSize:(CGSize)size;

@end
