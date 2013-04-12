//
//  YASearchBar.h
//  YAUIKit
//
//  Created by liu yan on 4/12/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YASearchBar : UIView<UITextFieldDelegate> {
  UIImageView *_backgroundImageView;
  void(^_cancelButtonBlock)();
  void(^_searchButtonBolock)();
  void(^_searchTextBeginEditBlock)();
}

@property (nonatomic, retain) UITextField *searchTextField;
@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, retain) UIImageView *inputBoxImageView;
@property (nonatomic, assign) UIEdgeInsets inputEdgeInsets;

- (void) setInputBoxImage:(UIImage *)inputBoxImage;
- (void) showCancelButton:(BOOL)show animate:(BOOL)animate;

- (void) setCancelBlock:(void(^)())cancelBlock;
- (void) setSearchBlock:(void(^)())searchBlock;
- (void) setDidBeginEditBlock:(void(^)())didBeginEditBlock;

@end
