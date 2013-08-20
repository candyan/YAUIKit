//
//  YADialogView.h
//  YAUIKit
//
//  Created by 芈峮 on 13-8-15.
//  Copyright (c) 2013年 liu yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YADialogView : UIView

@property (nonatomic, unsafe_unretained) UIView *contentView;
@property (nonatomic, unsafe_unretained) UIButton * cancelButton;
@property (nonatomic, unsafe_unretained) UIButton * confirmButton;
@property (nonatomic, unsafe_unretained) UILabel * titleLable;
@property (nonatomic, strong) UIColor *backgroundViewColor;

- (id) initWithTitle:(NSString *)title;

- (void) setCancelButton:(NSString *)title block:(void(^)())block;

- (void) setConfirmButton:(NSString *)title block:(void(^)())block;

- (void) setContentView:(UIView *)contentView;

- (void) showToView:(UIView *)toView;

@end
