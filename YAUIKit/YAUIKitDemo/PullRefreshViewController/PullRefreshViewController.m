//
//  PullRefreshViewController.m
//  YAUIKit
//
//  Created by liu yan on 4/16/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "PullRefreshViewController.h"

@interface PullRefreshViewController ()<UITableViewDataSource, UITableViewDelegate, YAPullRefreshDelegate> {
  YAPullRefreshController *_yprc;
  UILabel *_refreshHeaderView;
  UILabel *_refreshFooterView;
  
  NSMutableArray *_numberArray;
}

@end

@implementation PullRefreshViewController

#pragma mark -  init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  [self.view setBackgroundColor:[UIColor whiteColor]];
  _numberArray = [NSMutableArray arrayWithObjects:@1, @2, @3, @4, @5, @6, nil];
  [self.tableView setBackgroundView:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  __weak typeof(self) weakSelf = self;
  [self.tableView addRefreshControlWithActionHandler:^{
    [weakSelf refreshNumber];
  }];
  
  [self.tableView.refreshControl beginRefresh];
}

#pragma mark - Prop

- (UITableView *)tableView
{
  if (!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight
                                     | UIViewAutoresizingFlexibleWidth)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
  }
  return _tableView;
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_numberArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellIdentify = @"NumberCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentify];
  }
  
  [cell.textLabel setText:[NSString stringWithFormat:@"%@", [_numberArray objectAtIndex:indexPath.row]]];
  return cell;
}

#pragma mark - refresh Method
- (void) refreshNumber {
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    [_numberArray removeAllObjects];
    for (NSInteger index = 0; index < 7; index++) {
      [_numberArray addObject:@(random())];
    }
    sleep(15);
    dispatch_async(dispatch_get_main_queue(), ^{
      [_tableView reloadData];
      
      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
      NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"];
      [formatter setLocale:locale];
      
      [formatter setDateFormat:@"HH:mm:ss"];
      
      [self.tableView.refreshControl setSubTitle:[formatter stringFromDate:[NSDate date]] forState:(kYARefreshStateStopped
                                                                                     | kYARefreshStateTriggered
                                                                                     | kYARefreshStateLoading)];
      
      [self.tableView.refreshControl endRefresh];
    });
  });
}

- (void) loadMoreNumber {
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    [_numberArray addObject:[NSNumber numberWithInteger:[_numberArray count]]];
    sleep(2);
    dispatch_async(dispatch_get_main_queue(), ^{
      [_tableView reloadData];
      [_refreshFooterView setText:@"上拉加载更多"];
      [_yprc finishRefreshWithDirection:kYARefreshDirectionButtom animated:YES complate:nil];
    });
  });
}

@end
