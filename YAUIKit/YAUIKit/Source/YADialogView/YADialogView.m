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


static CGFloat const kAlertViewMinimumHeight  = 130.f;
static CGFloat const kalertViewFrameWidth = 300.f;
static CGFloat const kAlertViewPadding = 20.f;
static CGFloat const kAlertButtonHeight = 36.0;
static CGFloat const kAlertButtonWidth = 120.0f;

@interface YADialogView ()

@property (nonatomic,strong) UIButton * cancelButton;
@property (nonatomic,strong) UIButton * confirmButton;

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
      [self setBackgroundColor:[UIColor colorWithHex:0x000000 alpha:0.8f]];
    }
    return self;
}

- (id) initWithTitle:(NSString *)title{
  self = [self initWithFrame:CGRectMake(0, 0, kalertViewFrameWidth, kAlertViewMinimumHeight)];
  if (self) {
    
    [self.layer setCornerRadius:4.0f];
    [self.layer setMasksToBounds:YES];
    
    UILabel *titleLable = [self titleLable];
    [titleLable setText:title];
    
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
  
  UIView *backgroundView = [[UIView alloc] initWithFrame:toView.bounds];
  [backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
  [backgroundView setAlpha:0];
  [backgroundView setBackgroundColor:[UIColor blackColor]];
  [backgroundView setTag:899];
  [toView addSubview:backgroundView];

  CGFloat currentAlertViewHeight = CGRectGetHeight(_contentView.frame) + kAlertViewPadding + kAlertButtonHeight + kAlertButtonHeight;
  [self setFrame:CGRectMake(0, 0, kalertViewFrameWidth, currentAlertViewHeight)];
  [self setCenter:toView.center];
  
  [self setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin];
  
  [toView addSubview:self];
  
  [UIView animateWithDuration:0.5f
                   animations:^{
                     [backgroundView setAlpha:0.8];
                     [self setAlpha:1.f];
                     [self setCenter:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) * 0.5f,
                                                 CGRectGetHeight([[UIScreen mainScreen] bounds]) * 0.5f)];
                   } completion:^(BOOL finished){
                     
                   }];
}

- (void) setContentView:(UIView *)contentView {
  CGFloat width = (CGRectGetWidth(contentView.frame) > kalertViewFrameWidth - (kAlertViewPadding * 2)) ? kalertViewFrameWidth - (kAlertViewPadding * 2) : CGRectGetWidth(contentView.frame);
  [contentView setFrame:CGRectMake((kalertViewFrameWidth - width) * 0.5f, kAlertViewPadding * 0.4 + kAlertButtonHeight, width, CGRectGetHeight(contentView.frame))];
  [self addSubview:contentView];
  _contentView = contentView;
  
  [_confirmButton setCenter:CGPointMake(CGRectGetMidX(_confirmButton.frame), CGRectGetMidY(_confirmButton.frame) + CGRectGetHeight(contentView.frame))];
  [_cancelButton setCenter:CGPointMake(CGRectGetMidX(_cancelButton.frame), CGRectGetMidY(_cancelButton.frame) + CGRectGetHeight(contentView.frame))];
}

- (UILabel *) titleLable{
  UILabel * titleLable = [[UILabel alloc] init];
  [titleLable setBackgroundColor:[UIColor clearColor]];
  [titleLable setTextColor:[UIColor whiteColor]];
  [titleLable setFont:[UIFont fontWithName:@"Helvetica" size:18.f]];
  [titleLable setTextAlignment:NSTextAlignmentCenter];
  [titleLable sizeToFit];
  [titleLable setFrame:CGRectMake(kAlertViewPadding,
                                  kAlertViewPadding * 0.2,
                                  kalertViewFrameWidth - (kAlertViewPadding * 2),
                                  kAlertButtonHeight)];
  [self addSubview:titleLable];
  return titleLable;
}

- (void) addConfirmButton {
  
  _confirmButton = [self commonButton];
  [_confirmButton setFrame:CGRectMake(kalertViewFrameWidth - kAlertButtonWidth - kAlertViewPadding,
                                      CGRectGetHeight(_contentView.frame) + kAlertViewPadding * 0.7 + kAlertButtonHeight, kAlertButtonWidth, kAlertButtonHeight)];
  [_confirmButton addTarget:self action:@selector(tappedConfirm) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_confirmButton];
  
}

- (void) addCancelButton {
  
  _cancelButton = [self commonButton];
  [_cancelButton setFrame:CGRectMake(kAlertViewPadding ,
                                      CGRectGetHeight(_contentView.frame) + kAlertViewPadding * 0.7 + kAlertButtonHeight, kAlertButtonWidth, kAlertButtonHeight)];
  [_cancelButton addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_cancelButton];
  
}

- (UIButton *) commonButton {
  UIButton * commonButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [commonButton.layer setCornerRadius:4.f];
  [commonButton.layer setMasksToBounds:YES];
  [commonButton.layer setBorderWidth:1.f];
  [commonButton.layer setBorderColor:[UIColor colorWithRed:44.f/255.f green:45.f/255.f blue:50.f/255.f alpha:1.0f].CGColor];
  [commonButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [commonButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.f]];
  [commonButton setBackgroundColor:[UIColor colorWithHex:0x000000 alpha:0.8f]];
  return commonButton;
}

- (void)tappedConfirm
{
  [self dismissWithBlock:_confirmBlock];
}

////////////////////////////////////////////////////////
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
                     [[NSNotificationCenter defaultCenter] removeObserver:self];
                     [backgroundView removeFromSuperview];
                     [self removeFromSuperview];
                     if( block ) block();
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
