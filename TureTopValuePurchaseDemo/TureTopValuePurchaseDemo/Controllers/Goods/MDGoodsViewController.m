//
//  MDGoodsViewController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/1.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDGoodsViewController.h"

@interface MDGoodsViewController ()

@end

@implementation MDGoodsViewController

@synthesize categoryId,keyword;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark private methods
-(void)initData{
    
}

-(void)initView{
    UIView *navigationView = [[UIView alloc] init];
    [navigationView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:navigationView];
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.mas_equalTo(64);
    }];
    
    UILabel *bottomView = [[UILabel alloc] init];
    [bottomView setBackgroundColor:UIColorFromRGBA(170, 170, 170, 1)];
    [navigationView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navigationView.mas_left).with.offset(0);
        make.right.equalTo(navigationView.mas_right).with.offset(0);
        make.bottom.equalTo(navigationView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(0.5);
    }];
    UIView *rightView = [[UIView alloc] init];
    [navigationView addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.bottom.equalTo(bottomView.mas_top).with.offset(-6);
        make.right.equalTo(navigationView.mas_right).with.offset(-8);
    }];
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setTitle:@"取消" forState:UIControlStateNormal ];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [backButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backTap:) forControlEvents:UIControlEventTouchDown];
    [rightView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.bottom.equalTo(bottomView.mas_top).with.offset(-6);
        make.left.equalTo(navigationView.mas_left).with.offset(8);
    }];
    
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal ];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(backTap:) forControlEvents:UIControlEventTouchDown];
    [rightView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.bottom.equalTo(bottomView.mas_top).with.offset(-6);
        make.right.equalTo(navigationView.mas_right).with.offset(-8);
    }];
    
    
    UIView *searchBarView = [self bringSearchBar];
    [navigationView addSubview:searchBarView];
    [searchBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.bottom.equalTo(bottomView.mas_top).with.offset(-6);
        make.right.equalTo(cancelButton.mas_left).with.offset(-5);
        make.left.equalTo(backButton.mas_right).with.offset(8);
    }];

}


/*!
 *  创建搜索栏
 *
 *  @return 返回搜索栏对象
 */
-(UIView*)bringSearchBar{
    UIView *searchBarView = [[UIView alloc] init];
    [searchBarView.layer setBorderColor:[UIColorFromRGBA(170, 170, 170, 1) CGColor]];
    [searchBarView.layer setBorderWidth:0.5];
    [searchBarView.layer setCornerRadius:2];
    [searchBarView.layer setMasksToBounds:YES];
    [searchBarView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *searchView = [[UIView alloc] init];
    [searchBarView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchBarView.mas_top).with.offset(0);
        make.bottom.equalTo(searchBarView.mas_bottom).with.offset(0);
        make.left.equalTo(searchBarView.mas_left).with.offset(0);
        make.right.equalTo(searchBarView.mas_right).with.offset(0);
        
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageView setTag:1002];
    [imageView setImage:[UIImage imageNamed:@"icon_question_search"]];
    [searchView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.left.equalTo(searchView.mas_left).with.offset(8);
        make.centerY.equalTo(searchView);
    }];
    
    UITextField *searchText = [[UITextField alloc] initWithFrame:CGRectZero];
    [searchText setTextAlignment:NSTextAlignmentLeft];
    [searchText setTextColor:[UIColor grayColor]];
    [searchText setFont:[UIFont systemFontOfSize:14]];
    [searchText setPlaceholder:@"搜索商品和店铺"];
    [searchView addSubview:searchText];
    [searchText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchView.mas_top).with.offset(0);
        make.bottom.equalTo(searchView.mas_bottom).with.offset(0);
        make.left.equalTo(imageView.mas_right).with.offset(8);
        make.right.equalTo(searchView.mas_right).with.offset(5);
    }];
    
    return searchBarView;
}


@end
