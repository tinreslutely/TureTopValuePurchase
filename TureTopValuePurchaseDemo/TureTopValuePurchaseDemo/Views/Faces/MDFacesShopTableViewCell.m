//
//  MDFacesShopTableViewCell.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/14.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDFacesShopTableViewCell.h"

@implementation MDFacesShopTableViewCell

@synthesize imageView,positionLabel,titleLabel,subLabel,typeLabel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self initFacesPayCell];
    }
    return self;
}

/**
 *  创建店铺列表tableView 的 cell
 *
 *  @param identifier cell的identifier
 *
 *  @return UITableViewCell
 */
-(void)initFacesPayCell{
    
    imageView = [[UIImageView alloc] init];
    [imageView setTag:1001];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(8);
    }];
    
    
    positionLabel = [[UILabel alloc] init];
    [positionLabel setTag:1005];
    [positionLabel setTextColor:[UIColor grayColor]];
    [positionLabel setFont:[UIFont systemFontOfSize:12]];
    [positionLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:positionLabel];
    [positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 50));
        make.right.equalTo(self.mas_right).with.offset(-8);
        make.top.equalTo(self.mas_top).with.offset(8);
    }];
    
    titleLabel = [[UILabel alloc] init];
    [titleLabel setTag:1002];
    [titleLabel setNumberOfLines:2];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.left.equalTo(imageView.mas_right).with.offset(8);
        make.right.equalTo(positionLabel.mas_left).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(0);
    }];
    
    subLabel = [[UILabel alloc] init];
    [subLabel setTag:1003];
    [subLabel setFont:[UIFont systemFontOfSize:12]];
    [subLabel setTextColor:[UIColor greenColor]];
    [subLabel setTextAlignment:NSTextAlignmentCenter];
    [subLabel.layer setBorderColor:[[UIColor greenColor] CGColor]];
    [subLabel.layer setBorderWidth:1];
    [subLabel.layer setMasksToBounds:YES];
    [subLabel.layer setCornerRadius:5];
    [self addSubview:subLabel];
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.equalTo(imageView.mas_right).with.offset(8);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(0);
    }];
    
    typeLabel = [[UILabel alloc] init];
    [typeLabel setTag:1004];
    [typeLabel setTextColor:[UIColor grayColor]];
    [typeLabel setFont:[UIFont systemFontOfSize:12]];
    [typeLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.right.equalTo(self.mas_right).with.offset(-8);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(0);
    }];
}

@end
