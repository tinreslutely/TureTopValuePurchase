//
//  LDSearchBar.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/13.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "LDSearchBar.h"

@implementation LDSearchBar

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self.layer setBorderColor:[[UIColor grayColor] CGColor]];
        [self.layer setBorderWidth:1];
        [self.layer setCornerRadius:5];
        [self.layer setMasksToBounds:YES];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self initView];
    }
    return self;
}

#pragma mark private methods
-(void)initView{
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
    [textField setFont:[UIFont systemFontOfSize:12]];
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
