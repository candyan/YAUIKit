//
//  YATextEditorViewController.m
//  YAUIKit
//
//  Created by liuyan on 14-10-15.
//  Copyright (c) 2014年 liu yan. All rights reserved.
//

#import "YATextEditorViewController.h"
#import "UIFont+YAUIKit.h"
#import "UIView+YAUIKit.h"
#import <Masonry/Masonry.h>

@interface YATextEditorViewController ()

@end

@implementation YATextEditorViewController

#pragma mark - view lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(ya_keyboardWillShowNotification:)
                   name:UIKeyboardWillShowNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(ya_keyboardWillHiddenNotification:)
                   name:UIKeyboardWillHideNotification
                 object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Accessor

- (void)setEdgesForExtendedLayout:(UIRectEdge)edgesForExtendedLayout
{
    [super setEdgesForExtendedLayout:edgesForExtendedLayout];

    [self.editContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)] &&
            (self.edgesForExtendedLayout == UIRectEdgeTop || self.edgesForExtendedLayout == UIRectEdgeAll)) {
            make.top.equalTo(self.view).with.offset(64);
        } else {
            make.top.equalTo(self.view).with.offset(0);
        }
    }];
}

#pragma mark - Property

- (UIView *)editContainer
{
    if (_editContainer == nil) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = self.view.backgroundColor;
        _editContainer = view;
        [self.view addSubview:_editContainer];

        [_editContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            if ([self respondsToSelector:@selector(edgesForExtendedLayout)] &&
                (self.edgesForExtendedLayout == UIRectEdgeTop || self.edgesForExtendedLayout == UIRectEdgeAll)) {
                make.top.equalTo(self.view).with.offset(64);
            } else {
                make.top.equalTo(self.view).with.offset(0);
            }
            make.bottom.equalTo(self.view).with.offset(0);
            make.leading.equalTo(self.view);
            make.trailing.equalTo(self.view);
        }];
    }
    return _editContainer;
}

- (YAPlaceHolderTextView *)inputTextView
{
    if (_inputTextView == nil) {
        YAPlaceHolderTextView *textView = [[YAPlaceHolderTextView alloc] initWithFrame:CGRectZero];
        _inputTextView = textView;

        _inputTextView.font = [UIFont helveticaFontOfSize:15.0];

        [self.editContainer addSubview:_inputTextView];

        [_inputTextView mas_makeConstraints:^(MASConstraintMaker *make) { make.edges.equalTo(self.editContainer); }];
    }
    return _inputTextView;
}

#pragma mark - Action

- (void)sendAction:(id)sender
{
    // TODO: Implementation in subclass.
}

- (void)cancelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 if ([self.delegate respondsToSelector:@selector(textEditorControllerDidCancel:)]) {
                                     [self.delegate textEditorControllerDidCancel:self];
                                 }
                             }];
}

#pragma mark - keyboard notification

- (void)ya_keyboardWillShowNotification:(NSNotification *)notification
{
	if (self.automaticallyAdjustsEditContainer == NO) {
        return;
    }
    
    NSDictionary *userInfo = notification.userInfo;

    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat keyboardHeight = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

    [self.editContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-keyboardHeight);
    }];

    [self.view setNeedsLayout];

    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:animationCurve
                     animations:^{ [self.view layoutIfNeeded]; }
                     completion:nil];
}

- (void)ya_keyboardWillHiddenNotification:(NSNotification *)notification
{
	if (self.automaticallyAdjustsEditContainer == NO) {
        return;
    }

    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];

    [self.editContainer
     mas_updateConstraints:^(MASConstraintMaker *make) { make.bottom.equalTo(self.view).with.offset(0); }];

    [self.view setNeedsLayout];

    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:animationCurve
                     animations:^{ [self.view layoutIfNeeded]; }
                     completion:nil];
}

@end
