//
//  AlertAndASViewController.m
//  YAUIKit
//
//  Created by liu yan on 4/10/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "AlertAndASViewController.h"
#import "UINavigationController+Demo.h"

@interface AlertAndASViewController ()

@end

@implementation AlertAndASViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickAlertButton:(id)sender {
  YAAlertView *alertView = [[YAAlertView alloc] initWithTitle:@"重要提示" message:@"这是一个Alert View 噢~~~"];
  [alertView setCancelButtonWithTitle:@"我是取消噢" block:nil];
  [alertView addButtonWithTitle:@"我是ActionSheet噢" block:^{
    [self clickShowActionSheetButton:nil];
  }];
  [alertView show];
}

- (IBAction)clickShowActionSheetButton:(id)sender {
  YAActionSheet *actionSheet = [[YAActionSheet alloc] initWithTitle:@"我是个ActionSheet噢~~~"];
  [actionSheet setDestructiveButtonWithTitle:@"这里是一个超级危险的东东" block:^{
    YAAlertView *alertView = [[YAAlertView alloc] initWithTitle:@"确定要点这个危险的东东" message:nil];
    [alertView addButtonWithTitle:@"确定了" block:^{
      [self.navigationController popViewControllerWithDemoAnimation];
    }];
    [alertView show];
  }];
  [actionSheet addButtonWithTitle:@"我是Alert View噢" block:^{
    [self clickAlertButton:nil];
  }];
  [actionSheet setCancelButtonWithTitle:@"这里是取消" block:nil];
  [actionSheet showInView:self.view];
}
@end
