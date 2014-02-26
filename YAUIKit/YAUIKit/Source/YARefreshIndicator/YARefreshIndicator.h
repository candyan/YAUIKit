//
//  YARefreshIndicator.h
//  YAUIKit
//
//  Created by liuyan on 13-9-24.
//  Copyright (c) 2013年 Douban Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YARefreshIndicator : UIView

@property (nonatomic, readonly) BOOL loading;
@property (nonatomic, assign) BOOL hidesWhenStop;

- (void)setIndicatorColor:(UIColor *)color;

- (void)startLoading;
- (void)stopLoading;

- (void)didLoaded:(float)present;

@end
