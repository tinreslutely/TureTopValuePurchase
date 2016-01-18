//
//  LDSearchBar.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/13.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "LDSearchBar.h"

@interface LDSearchBar()<UITextFieldDelegate>

@end

@implementation LDSearchBar

@synthesize searchTextFiled,leftButton,rightButton;


-(instancetype)initWithNavigationItem:(UINavigationItem*)navigationItem{
    if(self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-80, 31)]){
        [self.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [self.layer setBorderWidth:1];
        [self.layer setCornerRadius:2];
        [self.layer setMasksToBounds:YES];
        //[self setBackgroundColor:[UIColor whiteColor]];
        [self bringSearchBar];
        [self setupNavigationItem:navigationItem];
    }
    return self;
}

-(instancetype)initWithNavigationItem:(UINavigationItem*)navigationItem hasLeftButton:(BOOL)hasLeftButton{
    if(self = [super initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 80, 31)]){
        [self.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [self.layer setBorderWidth:1];
        [self.layer setCornerRadius:2];
        [self.layer setMasksToBounds:YES];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self bringSearchBar];
        hasLeftButton ? [self setupNavigationItem:navigationItem] : [self setupNotLeftViewNavigationItem:navigationItem];
    }
    return self;
}

#pragma mark UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if([self.delegate respondsToSelector:@selector(searchBar:willStartEditingWithTextField:)]){
        [self.delegate searchBar:self willStartEditingWithTextField:textField];
    }
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

-(void)setupNotLeftViewNavigationItem:(UINavigationItem*)navigationItem{
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
    UIView *imageViewGroup = [[UIView alloc] init];
    [imageViewGroup setBackgroundColor:[UIColor whiteColor]];
    [self addSubview: imageViewGroup];
    [imageViewGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.centerY.equalTo(self);
    }];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageView setBackgroundColor:[UIColor whiteColor]];
    [imageView setImage:[UIImage imageNamed:@"icon_question_search"]];
    [imageViewGroup addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.center.equalTo(imageViewGroup);
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
    UIView *searchTextGroup = [[UIView alloc] init];
    [searchTextGroup setBackgroundColor:[UIColor whiteColor]];
    [searchTextGroup setAlpha:0.8];
    [self addSubview:searchTextGroup];
    [searchTextGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.left.equalTo(imageViewGroup.mas_right).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
    }];
    
    searchTextFiled = [[UITextField alloc] initWithFrame:CGRectZero];
    [searchTextFiled setTextAlignment:NSTextAlignmentLeft];
    [searchTextFiled setTextColor:[UIColor grayColor]];
    [searchTextFiled setFont:[UIFont systemFontOfSize:14]];
    [searchTextFiled setText:@"搜索商品"];
    [searchTextFiled setDelegate:self];
    [searchTextGroup addSubview:searchTextFiled];
    [searchTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchTextGroup.mas_top).with.offset(0);
        make.bottom.equalTo(searchTextGroup.mas_bottom).with.offset(0);
        make.left.equalTo(imageViewGroup.mas_right).with.offset(8);
        make.right.equalTo(searchTextGroup.mas_right).with.offset(5);
    }];
    
}

@end
