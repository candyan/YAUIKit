//
//  YAToggleView.h
//  YAUIKit
//
//  Created by liu yan on 4/11/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  kYAToggleStatusOn = 1 << 0,
  KYAToggleStatusOff = 1 << 1,
} YAToggleStatus;

typedef void(^ValueChangedBlock)(BOOL on);

@interface YAToggleView : UIView {
  UIImageView *_backgroundImageView;
  UIImageView *_toggleThumb;
  
  UIImage *_backgroundImageOn;
  UIImage *_backgroundImageOff;
  
  UIImage *_toggleThumbImageOn;
  UIImage *_toggleThumbImageOff;
  ValueChangedBlock _valueChangedBlock;
}

@property (nonatomic, assign) BOOL on;
@property (nonatomic, assign) UIEdgeInsets thumbEdgeInsets;

- (void)setValueChangedBlock:(void(^)(BOOL on))valueChangedBlock;

- (void) setBackgroundImage:(UIImage *)backgroundImage toggleStatus:(YAToggleStatus)toggleStatus;
- (void) setThumbImage:(UIImage *)thumbImage toggleStatus:(YAToggleStatus)toggleStatus;

- (void) setThumbSize:(CGSize)size;

@end
