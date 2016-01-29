//
//  MDSearchNormalTableViewCell.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/28.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDSearchNormalTableViewCell.h"

@implementation MDSearchNormalTableViewCell

@synthesize textLabel,iconButton;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self initView];
    }
    return self;
}


-(void)initView{
    iconButton = [[UIButton alloc] init];
    [self.contentView addSubview:iconButton];
    [iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.right.equalTo(self.contentView.mas_right).with.offset(-8);
        make.centerY.equalTo(self.contentView);
    }];
    textLabel = [[UILabel alloc] init];
    [self.contentView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.left.equalTo(self.contentView.mas_left).with.offset(14);
        make.right.equalTo(iconButton.mas_left).with.offset(-8);
        make.centerY.equalTo(self.contentView);
    }];
}
@end
