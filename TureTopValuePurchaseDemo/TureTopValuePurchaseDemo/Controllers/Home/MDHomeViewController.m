//
//  MDHomeViewController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/12.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDHomeViewController.h"

#import "LDSearchBar.h"

@interface MDHomeViewController ()

@end

@implementation MDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)initView{
    self.navigationItem.titleView = [[LDSearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 30)];
}

@end
