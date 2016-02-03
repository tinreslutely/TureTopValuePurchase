//
//  MDSearchNormalTableViewCell.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/28.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDSearchNormalTableViewCell.h"

@implementation MDSearchNormalTableViewCell{
    UILabel *_spaceLabel;
}

@synthesize textLabel,iconButton;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self initView];
    }
    return self;
}


-(void)initView{
    _spaceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_spaceLabel setBackgroundColor:UIColorFromRGBA(220, 220, 220, 1)];
    [self.contentView addSubview:_spaceLabel];
    [_spaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.equalTo(self.contentView.mas_left).with.offset(8);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
    }];
    
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

-(void)setSpaceLabelHidden:(BOOL)hidden{
    [_spaceLabel setHidden:hidden];
}
@end
