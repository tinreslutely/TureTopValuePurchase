//
//  MDPersonCenterOrderTableViewCell.m
//  TureTopValuePurchaseDemo
//  订单状态（待付款、待发货、待收货、待评价）的订单查询的UITableViewCell扩展类
//  Created by 李晓毅 on 16/1/26.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDPersonCenterOrderTableViewCell.h"

@implementation MDPersonCenterOrderTableViewCell

@synthesize noPaidBadge,noConsigneeBadge,noDispatchBadge,noEvalBadge;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self initView];
    }
    return self;
}

-(void)initView{
    NSArray *titleArray = @[@"待付款",@"待发货",@"待收货",@"待评价"];
    NSArray *iconArray = @[@"myValue1",@"myValue2",@"myValue3",@"myValue4"];
    float itemWidth = 60;
    float iconWidth = itemWidth/3;
    float itemOffsetX = (SCREEN_WIDTH-itemWidth*4)/(titleArray.count * 2);
    float iconOffsetY = (itemWidth - iconWidth - 25 - 2)/2;
    float pointX = itemOffsetX;
    for(int i = 0; i < titleArray.count; i++){
        UIControl *control = [[UIControl alloc] init];
        [self.contentView addSubview:control];
        [control mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(iconWidth + 27, iconWidth + 27));
            make.left.equalTo(self.contentView.mas_left).with.offset(pointX);
            make.centerY.equalTo(self.contentView);
        }];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setImage:[UIImage imageNamed:iconArray[i]]];
        [control addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(iconWidth, iconWidth));
            make.centerY.equalTo(control.mas_centerY).with.offset(-1*iconOffsetY);
            make.centerX.equalTo(control.mas_centerX);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        [label setText:titleArray[i]];
        [label setTextColor:[UIColor grayColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:12]];
        [control addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(control.mas_left).with.offset(0);
            make.right.equalTo(control.mas_right).with.offset(0);
            make.top.equalTo(imageView.mas_bottom).with.offset(2);
            make.height.mas_equalTo(25);
        }];
        M13BadgeView *badgeView = [[M13BadgeView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
        badgeView.font = [UIFont systemFontOfSize:10.0];
        badgeView.hidesWhenZero = YES;
        [control addSubview:badgeView];
        switch (i) {
            case 0:
                noPaidBadge = badgeView;
                break;
            case 1:
                noDispatchBadge = badgeView;
                break;
            case 2:
                noConsigneeBadge = badgeView;
                break;
            case 3:
                noEvalBadge = badgeView;
                break;
        }
        
        pointX += itemWidth+2*itemOffsetX;
    }
    
}

@end
