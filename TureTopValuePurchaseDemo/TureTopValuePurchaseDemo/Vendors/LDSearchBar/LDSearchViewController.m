//
//  LDSearchViewController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/16.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "LDSearchViewController.h"

@interface LDSearchViewController ()


@end

@implementation LDSearchViewController

@synthesize searchText;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)backTap:(UIButton*)button{
    [searchText resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(backTap:) forControlEvents:UIControlEventTouchDown];
    [navigationView addSubview:cancelButton];
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
        make.left.equalTo(navigationView.mas_left).with.offset(60);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            [searchBarView setFrame:CGRectMake(10, searchBarView.frame.origin.y, searchBarView.frame.size.width+50, 30)];
        } completion:^(BOOL finished) {
            if(finished) [searchText becomeFirstResponder];
        }];
    });
}

-(UIView*)bringSearchBar{
    UIView *searchBarView = [[UIView alloc] init];
    [searchBarView.layer setBorderColor:[UIColorFromRGBA(170, 170, 170, 1) CGColor]];
    [searchBarView.layer setBorderWidth:0.5];
    [searchBarView.layer setCornerRadius:2];
    [searchBarView.layer setMasksToBounds:YES];
    [searchBarView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageView setImage:[UIImage imageNamed:@"icon_question_search"]];
    [searchBarView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.left.equalTo(searchBarView.mas_left).with.offset(8);
        make.centerY.equalTo(searchBarView);
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
    
    searchText = [[UITextField alloc] initWithFrame:CGRectZero];
    [searchText setTextAlignment:NSTextAlignmentLeft];
    [searchText setTextColor:[UIColor grayColor]];
    [searchText setFont:[UIFont systemFontOfSize:14]];
    [searchText setPlaceholder:@"搜索商品"];
    //[searchText setDelegate:self];
    [searchBarView addSubview:searchText];
    [searchText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchBarView.mas_top).with.offset(0);
        make.bottom.equalTo(searchBarView.mas_bottom).with.offset(0);
        make.left.equalTo(imageView.mas_right).with.offset(8);
        make.right.equalTo(searchBarView.mas_right).with.offset(5);
    }];
    return searchBarView;
}
@end
