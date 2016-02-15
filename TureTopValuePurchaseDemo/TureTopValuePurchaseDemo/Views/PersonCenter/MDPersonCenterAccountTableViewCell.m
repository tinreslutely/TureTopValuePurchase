//
//  MDPersonCenterAccountTableViewCell.m
//  TureTopValuePurchaseDemo
//  用户账户信息（可用余额、冻结余额）的UITableViewCell扩展类
//  Created by 李晓毅 on 16/1/26.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDPersonCenterAccountTableViewCell.h"

@implementation MDPersonCenterAccountTableViewCell

@synthesize noneFreezeMoneyLabel,freezeMoneyLabel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self initCell];
    }
    return self;
}

-(void)initCell{
    float itemHeight = 60;
    float itemWidth = SCREEN_WIDTH/3;
    
    UIView *freezeMoneyView = [[UIView alloc] init];
    [self.contentView addSubview:freezeMoneyView];
    [freezeMoneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(itemWidth, itemHeight));
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
    }];
    
    freezeMoneyLabel = [[UILabel alloc] init];
    [freezeMoneyLabel setTextAlignment:NSTextAlignmentCenter];
    [freezeMoneyLabel setFont:[UIFont systemFontOfSize:14]];
    [freezeMoneyView addSubview: freezeMoneyLabel];
    [freezeMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.top.equalTo(freezeMoneyView.mas_top).with.offset(5);
        make.left.equalTo(freezeMoneyView.mas_left).with.offset(0);
        make.right.equalTo(freezeMoneyView.mas_right).with.offset(0);
        
    }];
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setTextColor:[UIColor grayColor]];
    [titleLabel setText:@"可用余额"];
    [freezeMoneyView addSubview: titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.top.equalTo(freezeMoneyLabel.mas_bottom).with.offset(0);
        make.left.equalTo(freezeMoneyView.mas_left).with.offset(0);
        make.right.equalTo(freezeMoneyView.mas_right).with.offset(0);
    }];
    
    
    UIView *noneFreezeMoneyView = [[UIView alloc] init];
    [self.contentView addSubview:noneFreezeMoneyView];
    [noneFreezeMoneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(itemWidth, itemHeight));
        make.left.equalTo(freezeMoneyView.mas_right).with.offset(0);
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
    }];
    
    noneFreezeMoneyLabel = [[UILabel alloc] init];
    [noneFreezeMoneyLabel setTextAlignment:NSTextAlignmentCenter];
    [noneFreezeMoneyLabel setFont:[UIFont systemFontOfSize:14]];
    [noneFreezeMoneyView addSubview: noneFreezeMoneyLabel];
    [noneFreezeMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.top.equalTo(noneFreezeMoneyView.mas_top).with.offset(5);
        make.left.equalTo(noneFreezeMoneyView.mas_left).with.offset(0);
        make.right.equalTo(noneFreezeMoneyView.mas_right).with.offset(0);
        
    }];
    titleLabel = [[UILabel alloc] init];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setTextColor:[UIColor grayColor]];
    [titleLabel setText:@"冻结余额"];
    [noneFreezeMoneyView addSubview: titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.top.equalTo(noneFreezeMoneyLabel.mas_bottom).with.offset(0);
        make.left.equalTo(noneFreezeMoneyView.mas_left).with.offset(0);
        make.right.equalTo(noneFreezeMoneyView.mas_right).with.offset(0);
    }];
    
}

@end
