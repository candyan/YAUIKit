//
//  YARefreshIndicator.h
//  YAUIKit
//
//  Created by Candyan on 13-9-24.
//  Copyright (c) 2013 Candyan. All rights reserved.
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
