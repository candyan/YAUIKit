//
//  YATextEditorViewController.h
//  YAUIKit
//
//  Created by liuyan on 14-10-15.
//  Copyright (c) 2014年 liu yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YAPlaceHolderTextView.h"

@class YATextEditorViewController;

@protocol YATextEditorControllerDelegate <NSObject>

@optional
- (void)textEditorControllerDidCancel:(YATextEditorViewController *)textEditorController;

@end

@interface YATextEditorViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIView *editContainer;
@property (nonatomic, weak) IBOutlet YAPlaceHolderTextView *inputTextView;
@property (nonatomic, weak) IBOutlet id<YATextEditorControllerDelegate> delegate;
@property (nonatomic, assign) BOOL automaticallyAdjustsEditContainer;

- (IBAction)sendAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

@end
