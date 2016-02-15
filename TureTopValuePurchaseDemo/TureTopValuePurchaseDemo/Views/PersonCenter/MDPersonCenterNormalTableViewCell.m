//
//  MDPersonCenterNormalTableViewCell.m
//  TureTopValuePurchaseDemo
//  个人中心 - 通用UITableViewCell扩展类
//  Created by 李晓毅 on 16/1/26.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDPersonCenterNormalTableViewCell.h"

@implementation MDPersonCenterNormalTableViewCell{
    float _iconSizeWidth;
}

@synthesize iconImageView,titleLabel,subLabel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        _iconSizeWidth = 18;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self initCell];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void)initCell{
    iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(_iconSizeWidth, _iconSizeWidth));
        make.left.equalTo(self.contentView.mas_left).with.offset(16);
        make.centerY.equalTo(self.contentView);
    }];
    
    UIImageView *rightIconImageView = [[UIImageView alloc] init];
    [rightIconImageView setImage:[UIImage imageNamed:@"arrow_right"]];
    [rightIconImageView setAlpha:0.5];
    [self.contentView addSubview:rightIconImageView];
    [rightIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.equalTo(self.contentView.mas_right).with.offset(-8);
        make.centerY.equalTo(self.contentView);
    }];
    
    subLabel = [[UILabel alloc] init];
    [subLabel setFont:[UIFont systemFontOfSize:12]];
    [subLabel setTextAlignment:NSTextAlignmentRight];
    [subLabel setTextColor:UIColorFromRGBA(200, 200, 200, 1)];
    [self.contentView addSubview:subLabel];
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 25));
        make.right.equalTo(rightIconImageView.mas_left).with.offset(-5);
        make.centerY.equalTo(self.contentView);
    }];
    
    titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.left.equalTo(iconImageView.mas_right).with.offset(8);
        make.right.equalTo(subLabel.mas_left).with.offset(-5);
        make.centerY.equalTo(self.contentView);
    }];
}

@end
