//
//  MDSearchViewController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/16.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDSearchViewController.h"
#import "LDSearchBar.h"

@interface MDSearchViewController ()

@end

@implementation MDSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    LDSearchBar *searchBar = [[LDSearchBar alloc] initWithNavigationItem:self.navigationItem hasLeftButton:NO];
    [searchBar.layer setBorderColor:[UIColorFromRGBA(170, 170, 170, 1) CGColor]];
    
    [UIView animateWithDuration:1 animations:^{
        self.navigationItem.leftBarButtonItem = nil;
        [searchBar setFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 31)];
    } completion:^(BOOL finished) {
        if(finished)[searchBar.searchTextFiled becomeFirstResponder];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
