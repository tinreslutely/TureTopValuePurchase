//
//  MDHomeViewController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/12.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDHomeViewController.h"
#import "MDHomeDataController.h"
#import "MDNavigationController.h"
#import "LDSearchBar.h"

@interface MDHomeViewController ()

@end

@implementation MDHomeViewController{
    
    UITableView *_mainTableView;
    MDHomeDataController *_dataController;
}

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self initData];
    [self initView];
}

-(void)viewDidAppear:(BOOL)animated{
    [((MDNavigationController*)self.navigationController) setAlpha:0.001];
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark action and event methods
-(void)refreshData{
    [_dataController refreshDataWithCompletion:^(BOOL state){
        [_mainTableView.mj_header endRefreshing];
        if(state) [_mainTableView reloadData];
    }];
}

#pragma mark private methods
-(void)initData{
    _dataController = [[MDHomeDataController alloc] init];
    __weak typeof(self) weakSelf = self;
    _dataController.scrollBlock = ^(float scrollY){
        if(scrollY == 0){
            [((MDNavigationController*)weakSelf.navigationController) setAlpha:0.0001];
            [weakSelf.navigationController setNavigationBarHidden:NO animated:NO];
        }else if(scrollY > 0 && scrollY < 94){
            [((MDNavigationController*)weakSelf.navigationController) setAlpha:(scrollY * 0.01)];
            [weakSelf.navigationController setNavigationBarHidden:NO animated:NO];
        }else if(scrollY >= 94){
            [((MDNavigationController*)weakSelf.navigationController) setAlpha:0.94];
        }else if(scrollY < 0){
            [((MDNavigationController*)weakSelf.navigationController) setAlpha:0.0001];
            [weakSelf.navigationController setNavigationBarHidden:YES animated:NO];
        }
        
    };
}

-(void)initView{
    self.navigationItem.titleView = [[LDSearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-80, 30)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [imageView setImage:[UIImage imageNamed:@"valuepurchase-logo"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [imageView setImage:[UIImage imageNamed:@"valuepurchase-logo"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [_mainTableView setDelegate:_dataController];
    [_mainTableView setDataSource:_dataController];
    [_mainTableView setShowsVerticalScrollIndicator:NO];
    [_mainTableView setMj_header:[MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)]];
    [self.view addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
}

@end
