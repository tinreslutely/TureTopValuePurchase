//
//  MDShopManagementViewController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/12.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDShopManagementViewController.h"

@interface MDShopManagementViewController ()

@end

@implementation MDShopManagementViewController

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark action methods


#pragma mark private methods
/**
 *  初始化基本参数
 */
-(void)initData{
    
}

/**
 *  初始化界面
 */
-(void)initView{
    [self.leftButton setHidden:YES];
    
}

@end
