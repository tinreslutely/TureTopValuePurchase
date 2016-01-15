//
//  LDSearchBar.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/13.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "LDSearchBar.h"

@implementation LDSearchBar

@synthesize leftButton,rightButton;


-(instancetype)initWithNavigationItem:(UINavigationItem*)navigationItem{
    if(self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-80, 31)]){
        [self.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [self.layer setBorderWidth:1];
        [self.layer setCornerRadius:2];
        [self.layer setMasksToBounds:YES];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self bringSearchBar];
        [self setupNavigationItem:navigationItem];
    }
    return self;
}

#pragma mark private methods
-(void)setupNavigationItem:(UINavigationItem*)navigationItem{
    leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftButton setContentMode:UIViewContentModeScaleToFill];
    if(__IPHONE_SYSTEM_VERSION > 7){
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;
        navigationItem.leftBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:leftButton]];
    }
    else{
        [navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:leftButton]];
    }
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
    if(__IPHONE_SYSTEM_VERSION > 7){
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;
        navigationItem.rightBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:rightButton]];
    }
    else{
        [navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightButton]];
    }
    navigationItem.titleView = self;
}
-(void)bringSearchBar{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageView setImage:[UIImage imageNamed:@"icon_question_search"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.left.equalTo(self.mas_left).with.offset(8);
        make.centerY.equalTo(self);
    }];
    
//    UIButton *clearButton = [[UIButton alloc] init];
//    [clearButton setImage:[UIImage imageNamed:@"search_close"] forState:UIControlStateNormal];
//    [clearButton setContentMode:UIViewContentModeScaleAspectFit];
//    [self addSubview:clearButton];
//    [clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(self.frame.size.height/2, self.frame.size.height/2));
//        make.right.equalTo(self.mas_right).with.offset(0);
//        make.centerY.equalTo(self);
//    }];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    [textField setTextAlignment:NSTextAlignmentLeft];
    [textField setTextColor:[UIColor grayColor]];
    [textField setFont:[UIFont systemFontOfSize:14]];
    [textField setPlaceholder:@"搜索商品"];
    [self addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.left.equalTo(imageView.mas_right).with.offset(8);
        make.right.equalTo(self.mas_right).with.offset(5);
    }];
    
}

@end
