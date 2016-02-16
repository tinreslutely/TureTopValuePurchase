//
//  MDMemberNormalTableViewCell.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/15.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDMemberNormalTableViewCell.h"

@implementation MDMemberNormalTableViewCell
@synthesize detailLabel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        [self.textLabel setFont:[UIFont systemFontOfSize:14]];
        [self initCell];
    }
    return self;
}

-(void)initCell{
    detailLabel = [[UILabel alloc] init];
    [detailLabel setTextColor:UIColorFromRGBA(200, 200, 200, 1)];
    [detailLabel setFont:[UIFont systemFontOfSize:14]];
    [detailLabel setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(220, 30));
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.centerY.equalTo(self.contentView);
    }];
}

@end
