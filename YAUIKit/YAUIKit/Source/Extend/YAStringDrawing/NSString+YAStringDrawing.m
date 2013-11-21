//
//  NSString+YAStringDrawing.m
//  YAUIKit
//
//  Created by liuyan on 13-10-15.
//  Copyright (c) 2013年 Douban Inc. All rights reserved.
//

#import "NSString+YAStringDrawing.h"
#import <CoreText/CoreText.h>

@implementation NSString (YAStringDrawing)

- (CGSize)sizeWithAttributes:(NSDictionary *)attrs constrainedToSize:(CGSize)size
{
  NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self
                                                                         attributes:attrs];
  CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attributedString);
  CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, size, NULL);
  CFRelease(framesetter);
  return fitSize;
}

@end
