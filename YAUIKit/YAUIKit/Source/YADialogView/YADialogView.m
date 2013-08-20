//
//  YADialogView.m
//  YAUIKit
//
//  Created by 芈峮 on 13-8-15.
//  Copyright (c) 2013年 liu yan. All rights reserved.
//

#import "YADialogView.h"
#import "UIColor+YAHexColor.h"
#import <QuartzCore/QuartzCore.h>


static CGFloat const kDialogViewMinimumHeight  = 88.f;
static CGFloat const kDialogViewFrameWidth = 280.f;
static CGFloat const kDialogViewPadding = 10.f;
static CGFloat const kDialogButtonHeight = 28.f;
static CGFloat const kDialogButtonWidth = 102.f;
static CGFloat const kDialogLableHeight = 40.f;
static CGFloat const kDialogElementWidth = 225.f;


@interface YADialogView ()


@end

@implementation YADialogView
{
  void (^_confirmBlock)(void);
  void (^_cancelBlock)(void);
}

#pragma mark - init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithTitle:(NSString *)title{
  self = [self initWithFrame:CGRectMake(0, 0, kDialogViewFrameWidth, kDialogViewMinimumHeight)];
  if (self) {
    
    [self.layer setCornerRadius:4.0f];
    [self.layer setMasksToBounds:YES];
    
    _titleLable = [self titleLable];
    [_titleLable setText:title];
    _backgroundViewColor = [UIColor whiteColor];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self addCancelButton];
    [self addConfirmButton];
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  
}

#pragma mark - Prop
- (void) setCancelButton:(NSString *)title block:(void(^)())block
{
  [_cancelButton setTitle:title forState:UIControlStateNormal];
  _cancelBlock = [block copy];
}

- (void) setConfirmButton:(NSString *)title block:(void(^)())block
{
  [_confirmButton setTitle:title forState:UIControlStateNormal];
  _confirmBlock = [block copy];
}

- (void) showToView:(UIView *)toView
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden) name:UIKeyboardWillHideNotification object:nil];
  
  UIView * backgroudView = [[UIView alloc] initWithFrame:toView.bounds];
  [backgroudView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
  [backgroudView setAlpha:0.5f];
  [backgroudView setBackgroundColor:_backgroundViewColor];
  [backgroudView setTag:899];
  [toView addSubview:backgroudView];

  CGFloat currentAlertViewHeight = CGRectGetHeight(_contentView.frame) + (kDialogViewPadding * 2) + kDialogButtonHeight + kDialogLableHeight;
  [self setFrame:CGRectMake(0, 0, kDialogViewFrameWidth, currentAlertViewHeight)];
  [self setCenter:toView.center];
  
  [self setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin];
  
  [toView addSubview:self];
    
  [UIView animateWithDuration:0.5f
                   animations:^{
                     [backgroudView setAlpha:0.2];
                     [self setAlpha:1.f];
                     [self setCenter:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) * 0.5f,
                                                 CGRectGetHeight([[UIScreen mainScreen] bounds]) * 0.5f)];
                   } completion:^(BOOL finished){
                     
                   }];
}

- (void) setContentView:(UIView *)contentView {
  CGFloat width = (CGRectGetWidth(contentView.frame) > kDialogElementWidth) ? kDialogElementWidth : CGRectGetWidth(contentView.frame);
  [contentView setFrame:CGRectMake((kDialogViewFrameWidth - width) * 0.5f, kDialogLableHeight, width, CGRectGetHeight(contentView.frame))];
  [self addSubview:contentView];
  _contentView = contentView;
  
  [_confirmButton setCenter:CGPointMake(CGRectGetMidX(_confirmButton.frame), CGRectGetMidY(_confirmButton.frame) + CGRectGetHeight(contentView.frame))];
  [_cancelButton setCenter:CGPointMake(CGRectGetMidX(_cancelButton.frame), CGRectGetMidY(_cancelButton.frame) + CGRectGetHeight(contentView.frame))];
}

- (UILabel *) titleLable{
  UILabel * titleLable = [[UILabel alloc] init];
  [titleLable setBackgroundColor:[UIColor clearColor]];
  [titleLable setTextColor:[UIColor colorWithHex:0x005650 alpha:1.f]];
  [titleLable setFont:[UIFont fontWithName:@"Helvetica" size:15.f]];
  [titleLable setTextAlignment:NSTextAlignmentCenter];
  [titleLable sizeToFit];
  [titleLable setFrame:CGRectMake((kDialogViewFrameWidth - kDialogElementWidth) * 0.5,
                                  0,
                                  kDialogElementWidth,
                                  kDialogLableHeight)];
  [self addSubview:titleLable];
  return titleLable;
}

- (void) addConfirmButton {
  
  _confirmButton = [self commonButton];
  [_confirmButton setFrame:CGRectMake(kDialogViewFrameWidth - (kDialogViewFrameWidth - kDialogElementWidth) * 0.5 - kDialogButtonWidth,
                                      CGRectGetHeight(self.frame) - kDialogViewPadding - kDialogButtonHeight,
                                      kDialogButtonWidth,
                                      kDialogButtonHeight)];
  [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
  [_confirmButton setBackgroundColor:[UIColor colorWithHex:0x005650 alpha:1.f]];
  [_confirmButton addTarget:self action:@selector(tappedConfirm) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_confirmButton];
  
}

- (void) addCancelButton {
  
  _cancelButton = [self commonButton];
  [_cancelButton setFrame:CGRectMake((kDialogViewFrameWidth - kDialogElementWidth) * 0.5 ,
                                     CGRectGetHeight(self.frame) - kDialogViewPadding - kDialogButtonHeight ,
                                     kDialogButtonWidth,
                                     kDialogButtonHeight)];
  [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
  [_cancelButton setBackgroundColor:[UIColor colorWithHex:0x858585 alpha:1.f]];
  [_cancelButton addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_cancelButton];
  
}

- (UIButton *) commonButton {
  UIButton * commonButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [commonButton.layer setCornerRadius:4.f];
  [commonButton.layer setMasksToBounds:YES];
  [commonButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [commonButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:11.f]];
  //[commonButton setBackgroundColor:[UIColor colorWithHex:0x005650 alpha:1.f]];
  return commonButton;
}

- (void)tappedConfirm
{
  [self dismissWithBlock:_confirmBlock];
}

- (void)tappedCancel
{
  
  [self dismissWithBlock:_cancelBlock];
}

- (void)dismissWithBlock:(void(^)(void))block
{
  
  UIView *backgroundView = [self.superview viewWithTag:899];
  
  [UIView animateWithDuration:0.5f
                   animations:^{
                     [backgroundView setAlpha:0];
                     [self setAlpha:0.0f];
                     [self setCenter:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) * 0.5f,
                                                 CGRectGetHeight([[UIScreen mainScreen] bounds]) * 1.5f)];
                   } completion:^(BOOL finished){
                     if( block ) block();
                     [[NSNotificationCenter defaultCenter] removeObserver:self];
                     [backgroundView removeFromSuperview];
                     [self removeFromSuperview];
                   }
                   ];
                
                   
}

- (void)keyboardWillShow
{
  [UIView animateWithDuration:0.3f
                   animations:^{
                     [self setCenter:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) * 0.5f,
                                                 CGRectGetHeight([[UIScreen mainScreen] bounds]) * 0.3f)];
                   } completion:^(BOOL finished){
                   }
   ];

}

- (void)keyboardWillHidden
{
  [UIView animateWithDuration:0.3f
                   animations:^{
                     [self setCenter:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) * 0.5f,
                                                 CGRectGetHeight([[UIScreen mainScreen] bounds]) * 0.5f)];
                   } completion:^(BOOL finished){
                   }
   ];
}

@end
