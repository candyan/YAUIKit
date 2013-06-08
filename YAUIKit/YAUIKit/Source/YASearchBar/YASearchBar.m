//
//  YASearchBar.m
//  YAUIKit
//
//  Created by liu yan on 4/12/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "YASearchBar.h"
#import "UIView+YAUIKit.h"
#import <QuartzCore/QuartzCore.h>

CGFloat kSearchTextFieldEdgeLeft = 15.0;
CGFloat kSearchTextFieldEdgeTop = 6.0;

@implementation YASearchBar

@synthesize searchTextField = _searchTextField;
@synthesize cancelButton = _cancelButton;
@synthesize inputBoxImageView = _inputBoxImageView;
@synthesize inputEdgeInsets = _inputEdgeInsets;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    _inputEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [self createSubViews];
    [self showCancelButton:NO animate:NO];
  }
  return self;
}

#pragma mark - CreateSubView
- (void) createSubViews {
  
  _inputBoxImageView = [self createInputBoxImageView];
  [self setInputBoxImage:nil];
  [self addSubview:_inputBoxImageView];
  
  
  _searchTextField = [self createSearchTextField];
  [self addSubview:_searchTextField];
  
  _cancelButton = [self createCancelButton];
  [self addSubview:_cancelButton];
}

- (UIImageView *)createInputBoxImageView {
  UIImageView *inputImageView = [[UIImageView alloc] initWithFrame:
                                 CGRectMake(_inputEdgeInsets.left,
                                            _inputEdgeInsets.top,
                                            self.bounds.size.width - _inputEdgeInsets.left - _inputEdgeInsets.right,
                                            self.bounds.size.height - _inputEdgeInsets.top - _inputEdgeInsets.bottom)];
  [inputImageView setBackgroundColor:[UIColor clearColor]];
  inputImageView.layer.masksToBounds = YES;
  inputImageView.layer.shadowOffset = CGSizeZero;
  return inputImageView;
}

- (UITextField *) createSearchTextField {
  UITextField *searchTextField = [[UITextField alloc] initWithFrame:
                                  CGRectMake(_inputEdgeInsets.left + kSearchTextFieldEdgeLeft,
                                             _inputEdgeInsets.top + kSearchTextFieldEdgeTop,
                                             self.bounds.size.width - _inputEdgeInsets.left - _inputEdgeInsets.right - 2 * kSearchTextFieldEdgeLeft,
                                             self.bounds.size.height - _inputEdgeInsets.top - _inputEdgeInsets.bottom - 2 * kSearchTextFieldEdgeTop)];
  [searchTextField setPlaceholder:@"搜索"];
  [searchTextField setFont:[UIFont fontWithName:@"Helvetica" size:searchTextField.frame.size.height - 2]];
  [searchTextField setReturnKeyType:UIReturnKeySearch];
  [searchTextField setDelegate:self];
  [searchTextField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth];
  [searchTextField addTarget:self action:@selector(searchTextBeginEdit) forControlEvents:UIControlEventEditingDidBegin];
  return searchTextField;
}

- (UIButton *) createCancelButton {
  UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [cancelButton setFrame:CGRectMake(self.bounds.size.width - _inputEdgeInsets.right,
                                   _inputEdgeInsets.top,
                                   59,
                                    self.bounds.size.height - _inputEdgeInsets.top - _inputEdgeInsets.bottom)];
  [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
  [cancelButton setTitle:@"取消" forState:UIControlStateHighlighted];
  [cancelButton.titleLabel setFont:_searchTextField.font];
  [cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
  return cancelButton;
}

#pragma mark - Set
- (void) setInputBoxImage:(UIImage *)inputBoxImage {
  [_inputBoxImageView setImage:inputBoxImage];
  if (inputBoxImage) {
    [_inputBoxImageView.layer setCornerRadius:0];
    [_inputBoxImageView.layer setBorderWidth:0];
    _inputBoxImageView.layer.shadowOpacity = 0;
    _inputBoxImageView.layer.shadowPath = nil;
    _inputBoxImageView.layer.shadowRadius = 0;
  } else {
    [_inputBoxImageView.layer setCornerRadius:(_inputBoxImageView.frame.size.height / 2)];
    [_inputBoxImageView.layer setBorderWidth:1.0];
    [_inputBoxImageView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];    
    [_inputBoxImageView.layer setShadowColor:[[UIColor lightGrayColor]CGColor]];
    UIBezierPath* newShadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, _inputBoxImageView.bounds.size.width, 2)];
    _inputBoxImageView.layer.shadowOpacity = 0.8;
    _inputBoxImageView.layer.shadowPath = [newShadowPath CGPath];
    _inputBoxImageView.layer.shadowRadius = 1;
  }
}

- (void) setCancelBlock:(void(^)())cancelBlock {
  _cancelButtonBlock = cancelBlock;
}

- (void) setSearchBlock:(void(^)())searchBlock {
  _searchButtonBolock = searchBlock;
}

- (void) setDidBeginEditBlock:(void(^)())didBeginEditBlock {
  _searchTextBeginEditBlock = didBeginEditBlock;
}

#pragma mark - Animation
- (void)showCancelButton:(BOOL)show animate:(BOOL)animate {
  if (show) {
    if (animate) {
      [UIView animateWithDuration:.2f animations:^{
        [self setShowCancelButtonStatus:YES];
      }];
    } else {
      [self setShowCancelButtonStatus:YES];
    }
  } else {
    if (animate) {
      [UIView animateWithDuration:.2f animations:^{
        [self setShowCancelButtonStatus:NO];
      }];
    } else {
      [self setShowCancelButtonStatus:NO];
    }
  }
}

- (void) setShowCancelButtonStatus:(BOOL)show {
  CGFloat cancelButtonWidth = _cancelButton.frame.size.width;
  if (show) {
    [_inputBoxImageView setFrameWidth:(self.bounds.size.width - _inputEdgeInsets.right - _inputEdgeInsets.left - 5 - cancelButtonWidth)];
    [_searchTextField setFrameWidth:(self.bounds.size.width - 10 - cancelButtonWidth - 5)];
    
    [_cancelButton setFrameWidth:0];
    [_cancelButton setHidden:NO];
    [_cancelButton setFrameWidth:cancelButtonWidth];
    [_cancelButton setFrameOriginX:(self.bounds.size.width - _inputEdgeInsets.right - cancelButtonWidth)];
  } else {
    [_inputBoxImageView setFrameWidth:(self.bounds.size.width - _inputEdgeInsets.right - _inputEdgeInsets.left)];
    [_searchTextField setFrameWidth:_inputBoxImageView.frame.size.width - 30];
    
    [_cancelButton setFrameWidth:0];
    [_cancelButton setFrameOriginX:(self.bounds.size.width - _inputEdgeInsets.right)];
    [_cancelButton setHidden:YES];
  }
  [_cancelButton setFrameWidth:cancelButtonWidth];
}

#pragma mark - Event
- (void) clickCancelButton {
  [self showCancelButton:NO animate:YES];
  [_searchTextField resignFirstResponder];
  [_searchTextField setText:@""];
  if (_cancelButtonBlock) {
    _cancelButtonBlock();
  }
}

- (void) searchTextBeginEdit {
  [self showCancelButton:YES animate:YES];
  if (_searchTextBeginEditBlock) {
    _searchTextBeginEditBlock();
  }
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self showCancelButton:NO animate:YES];
  [_searchTextField resignFirstResponder];
  if (_searchButtonBolock) {
    _searchButtonBolock();
  }
  return YES;
}

@end
