//
//  ViewController.m
//  YAUIKitDemo
//
//  Created by liu yan on 4/9/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "ViewController.h"
#import "PlaceHolderTextViewController.h"

#import "UINavigationController+Demo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}


#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YAUIKitCell"];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YAUIKitCell"];
  }
  
  if (indexPath.row == 0) {
    [cell.textLabel setText:@"YA PlaceHolder TextView"];
  }
  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    PlaceHolderTextViewController *viewController = [[PlaceHolderTextViewController alloc] initWithNibName:@"PlaceHolderTextViewController" bundle:nil];
    [self.navigationController pushViewControllerWithDemoAnimation:viewController];
  }
}

@end
